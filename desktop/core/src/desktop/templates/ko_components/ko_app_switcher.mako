## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

<%!
from desktop import conf
from desktop.lib.i18n import smart_unicode

from django.utils.translation import ugettext as _
from desktop.views import _ko
%>

<%def name="appSwitcher()">

  <script type="text/html" id="hue-app-switcher-template">
    <ul class="cui-app-switcher nav navbar-nav">
      <li class="dropdown">
        <a style="padding: 10px 5px 0 5px; margin: 8px 24px 0 -5px;" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" role="button">
          <i class="fa fa-th"></i>
        </a>

        <ul class="dropdown-menu" style="margin: 7px 0 0 -5px;" role="menu">
          <!-- ko foreach: links -->
          <li class="nav-item">
            <!-- ko if: $data.divider -->
            <div class="divider"></div>
            <!-- /ko -->
            <!-- ko ifnot: $data.divider -->
            <a role="button" class="nav-link" data-bind="attr: {href: link}">
              <span class="app-switcher-app-icon">
                <!-- ko if: $data.icon -->
                <i data-bind="attr: {class: icon}"></i>
                <!-- /ko -->
                <!-- ko if: $data.img -->
                <!-- ko template: 'app-switcher-icon-template' --><!-- /ko -->
                <!-- /ko -->
              </span>
              <span class="app-switcher-app-name" data-bind="text: label, attr: {href: link}"></span>
            </a>
            <!-- /ko -->
          </li>
          <!-- /ko -->
        </ul>
      </li>
    </ul>
  </script>

  <script type="text/javascript">
    (function () {
      var apps = {
        cdsw: {
          label: 'Data Science',
          img:'hi-as-cdsw'
        },
        altusAdmin: {
          label: 'Altus Admin',
          img:'hi-as-nav'
        },
        hue: {
          label: 'Data Analytics (Hue)',
          img: 'hi-as-hue'
        },
        cm: {
          label: 'Cloudera Manager',
          img: 'hi-as-cm'
        },
        navigator: {
          label: 'Navigator',
          img: 'hi-as-nav'
        },
        navopt: {
          label: 'Data Engineering',
          img: 'hi-as-nav'
        }
      };

      var AppSwitcher = function AppSwitcher(params) {
        var self = this;

        self.links = ko.observableArray([]);

        var altusLinks = [{
            product: 'altusAdmin',
            link: 'https://sso.staging.aem.cloudera.com'
          }
        ];

        var onPremLinks = [{
            product: 'cdsw',
            link: '/'
          },
          {
            divider: true
          }
          , {
            product: 'cm',
            link: '/'
          }, {
            product: 'navigator',
            link: '/'
          }
        ];

        var applyLinks = function (links) {
          var newLinks = [];
          links.forEach(function (link) {
            if (link.product) {
              var lookup = apps[link.product];
              if (lookup) {
                lookup.link = link.link;
                newLinks.push(lookup);
              }
            } else {
              newLinks.push(link);
            }
          });
          self.links(newLinks);
        };

        params.onPrem.subscribe(function (newValue) {
          if (newValue) {
            applyLinks(onPremLinks);
          } else {
            applyLinks(altusLinks);
          }
        });

        applyLinks(altusLinks);
      };

      ko.components.register('hue-app-switcher', {
        viewModel: AppSwitcher,
        template: { element: 'hue-app-switcher-template' }
      });
    })();
  </script>

</%def>