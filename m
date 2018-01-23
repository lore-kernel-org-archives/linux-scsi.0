From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 23 Jan 2018 16:57:34 +0000
Message-ID: <1516726653.3339.20.camel@wdc.com>
References: <20180123161613.14214-1-ming.lei@redhat.com>
         <1516724659.3339.7.camel@sandisk.com> <20180123163717.GE13277@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1295 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbeAWQ5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2018 11:57:48 -0500
In-Reply-To: <20180123163717.GE13277@ming.t460p>
Content-Language: en-US
Content-ID: <D3F75E7348590E46A58932E4E1FE1443@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gV2VkLCAyMDE4LTAxLTI0IGF0IDAwOjM3ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
VHVlLCBKYW4gMjMsIDIwMTggYXQgMDQ6MjQ6MjBQTSArMDAwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IE15IG9waW5pb24gYWJvdXQgdGhpcyBwYXRjaCBpcyBhcyBmb2xsb3dzOg0KPiA+
ICogQ2hhbmdpbmcgYSBibGtfbXFfZGVsYXlfcnVuX2h3X3F1ZXVlKCkgY2FsbCBmb2xsb3dlZCBi
eSByZXR1cm4NCj4gPiAgIEJMS19TVFNfREVWX1JFU09VUkNFIGludG8gcmV0dXJuIEJMS19TVFNf
UkVTT1VSQ0UgaXMgd3JvbmcgYmVjYXVzZSBpdCBjaGFuZ2VzDQo+ID4gICBhIGd1YXJhbnRlZWQg
cXVldWUgcmVydW4gaW50byBhIHF1ZXVlIHJlcnVuIHRoYXQgbWF5IG9yIG1heSBub3QgaGFwcGVu
DQo+ID4gICBkZXBlbmRpbmcgb24gd2hldGhlciBvciBub3QgbXVsdGlwbGUgcXVldWUgcnVucyBo
YXBwZW4gc2ltdWx0YW5lb3VzbHkuDQo+IA0KPiBZb3UgbWF5IG5vdCB1bmRlcnN0YW5kIHRoZSB0
d286DQo+IA0KPiAxKSBpdCBpcyBhbHdheXMgc2FmZSB0byByZXR1cm4gQkxLX1NUU19SRVNPVVJD
RSwgd2hpY2ggd2lsbCBtYWtlIHN1cmUgdG8NCj4gYXZvaWQgSU8gaGFuZyBieSBibGtfbXFfZGVs
YXlfcnVuX2h3X3F1ZXVlKCkgb3IgYmxrX21xX3J1bl9od19xdWV1ZSgpLA0KPiBhbmQgdXNpbmcg
d2hpY2ggb25lIGRlcGVuZHMgb24gU0NIRURfUkVTVEFSVC4NCj4gDQo+IDIpIGlmIGRyaXZlciBj
YW4gbWFrZSBzdXJlIHRoZSBxdWV1ZSB3aWxsIGJlIHJlcnVuIGFmdGVyIHNvbWUgcmVzb3VyY2UN
Cj4gaXMgYXZhaWxhYmxlLCBlaXRoZXIgYnkgaXRzZWxmIG9yIGJ5IGJsay1tcSwgaXQgd2lsbCBy
ZXR1cm4gQkxLX1NUU19ERVZfUkVTT1VSQ0UNCj4gDQo+IFNvIHdoYXQgaXMgd3Jvbmcgd2l0aCB0
aGlzIHdheT8NCg0KU29ycnksIEkgc3dhcHBlZCBCTEtfU1RTX0RFVl9SRVNPVVJDRSBhbmQgQkxL
X1NUU19SRVNPVVJDRSBhY2NpZGVudGFsbHkgaW4gbXkNCnJlcGx5LiBXaGF0IEkgbWVhbnQgaXMg
dGhhdCBjaGFuZ2luZyBhIGJsa19tcV9kZWxheV9ydW5faHdfcXVldWUoKSBjYWxsIGZvbGxvd2Vk
DQpieSByZXR1cm4gQkxLX1NUU19SRVNPVVJDRSBpbnRvIEJMS19TVFNfREVWX1JFU09VUkNFIGlz
IHdyb25nIGFuZCBpbnRyb2R1Y2VzIGENCnJhY2UgY29uZGl0aW9uIGluIGNvZGUgd2hlcmUgdGhl
cmUgd2FzIG5vIHJhY2UgY29uZGl0aW9uLg0KDQpCYXJ0Lg==
