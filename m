From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: check for device state in __scsi_remove_target()
Date: Wed, 13 Dec 2017 22:23:18 +0000
Message-ID: <1513203795.2413.14.camel@wdc.com>
References: <1513171297-58020-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:33889 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751614AbdLMWXX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2017 17:23:23 -0500
In-Reply-To: <1513171297-58020-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <1FA151E460703344908CB21B47443BE1@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

T24gV2VkLCAyMDE3LTEyLTEzIGF0IDE0OjIxICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IEFzIGl0IHR1cm5lZCBvdXQgZGV2aWNlX2dldCgpIGRvZXNuJ3QgdXNlIGtyZWZfZ2V0X3Vu
bGVzc196ZXJvKCksDQo+IHNvIHdlIHdpbGwgYmUgYWx3YXlzIGdldHRpbmcgYSBkZXZpY2UgcG9p
bnRlci4NCj4gU28gd2UgbmVlZCB0byBjaGVjayBmb3IgdGhlIGRldmljZSBzdGF0ZSBpbiBfX3Nj
c2lfcmVtb3ZlX3RhcmdldCgpDQo+IHRvIGF2b2lkIHRyaXBwaW5nIG92ZXIgZGVsZXRlZCBvYmpl
Y3RzLg0KPiANCj4gRml4ZXM6IGZiY2U0ZDkgKCJzY3NpOiBmaXh1cCBrZXJuZWwgd2FybmluZyBk
dXJpbmcgcm1tb2QoKSIpDQoNCkhvdyBhYm91dCBhZGRpbmcgUmVwb3J0ZWQtYnk6IEphc29uIFlh
bj8gU2VlIGFsc28NCmh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2xpbnV4LXNjc2kvbXNn
MTE1Mjk1Lmh0bWwNCg0KQW55d2F5Og0KDQpSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxi
YXJ0LnZhbmFzc2NoZUB3ZGMuY29tPg0KDQo=
