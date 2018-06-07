From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: Fwd: [powerpc/Baremetal]Kernel OOPS while executing memory
 hotplug on Power8 baremetal
Date: Thu, 7 Jun 2018 07:42:51 +0000
Message-ID: <042fc8ee69b74c57815c0edfdbb253495e9d7718.camel@wdc.com>
References: <ee45ead1d96ad05f77aec1d8d3e39c85@linux.vnet.ibm.com>
 <d5b62afc48ece5aca8d08a80871c8613dd555d17.camel@wdc.com>
 <d011631b-c667-2628-dda8-2c87961329f0@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <d011631b-c667-2628-dda8-2c87961329f0@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <A7D5D2A706C1CE4CB94F66E27DBC7512@namprd04.prod.outlook.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "vrbagal1@linux.vnet.ibm.com" <vrbagal1@linux.vnet.ibm.com>
Cc: "sachinp@linux.vnet.ibm.com" <sachinp@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE4LTA2LTA3IGF0IDEyOjU2ICswNTMwLCBWZW5rYXQgUmFvIEIgd3JvdGU6DQo+
IE9uIFRodXJzZGF5IDA3IEp1bmUgMjAxOCAxMjo0NiBQTSwgQmFydCBWYW4gQXNzY2hlIHdyb3Rl
Og0KPiA+IE9uIFRodSwgMjAxOC0wNi0wNyBhdCAxMjozOCArMDUzMCwgdnJiYWdhbDEgd3JvdGU6
DQo+ID4gPiBPYnNlcnZpbmcgS2VybmVsIG9vcHMgYW5kIG1hY2hpbmUgcmVib290cyB3aGlsZSBl
eGVjdXRpbmcgbWVtb3J5IGhvdHBsdWcNCj4gPiA+IHRlc3QgY2FzZSwgb24gUG93ZXI4IEJhcmVt
ZXRhbCBtYWNoaW5lLg0KPiA+ID4gDQo+ID4gPiBJIHNlZSB0aGlzIGlzIGludHJvZHVjZWQgc29t
ZSB3aGVyZSBiZXR3ZWVuIHJjNiBhbmQgNC4xNy4NCj4gPiANCj4gPiBQbGVhc2UgcHJvdmlkZSB0
aGUgZXhhY3QgdmVyc2lvbnMgKGdpdCBjb21taXQgSURzKSBvZiB0aGUga2VybmVsIHZlcnNpb25z
DQo+ID4geW91IGhhdmUgdGVzdGVkLg0KPiANCj4gQ29tbWl0IElkIC0tLT4gNTAzN2JlMTY4Zg0K
DQpUaGUgcmVhc29uIEkgd2FzIGFza2luZyBmb3IgdGhlIGNvbW1pdCBJRCBpcyBiZWNhdXNlIEkg
c2F3IHRoYXQgY2xvbmVfZW5kaW8oKQ0Kb2NjdXJzIGluIHRoZSBvb3BzIHdoaWNoIG1lYW5zIHRo
YXQgdGhlIGRtIGRyaXZlciBpcyBpbnZvbHZlZC4gQW4gaW1wb3J0YW50IGZpeA0KZm9yIHRoZSBk
bSBkcml2ZXIgd2VudCB1cHN0cmVhbSByZWNlbnRseSwgbmFtZWx5IGQzNzc1MzU0MDU2OCAoImRt
OiBVc2Uga3phbGxvYw0KZm9yIGFsbCBzdHJ1Y3RzIHdpdGggZW1iZWRkZWQgYmlvc2V0cy9tZW1w
b29scyIpLiBDYW4geW91IGRvdWJsZSBjaGVjayB3aGV0aGVyDQp0aGF0IGNvbW1pdCBpdCBwcmVz
ZW50IGluIHlvdXIgdHJlZT8gSWYgaXQgaXMgbm90IHByZXNlbnQsIHBsZWFzZSB1cGRhdGUgdG8g
dGhlDQpsYXRlc3QgbWFzdGVyIGFuZCByZXRlc3QuIElmIGl0IGlzIHByZXNlbnQsIHBsZWFzZSBy
ZXBvcnQgaG93IHRvIHJlcHJvZHVjZQ0KdGhpcyBvb3BzIHRvIEtlbnQgT3ZlcnN0cmVldCwgSmVu
cyBBeGJvZSwgbGludXgtYmxvY2sgYW5kIE1pa2UgU25pdHplci4NCg0KVGhhbmtzLA0KDQpCYXJ0
Lg==
