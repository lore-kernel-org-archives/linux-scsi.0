From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3 06/12] scsi: sd_zbc: Rearrange code
Date: Fri, 15 Sep 2017 14:51:03 +0000
Message-ID: <1505487062.2852.12.camel@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
         <20170915100645.17999-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:8927 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdIOOv4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 10:51:56 -0400
In-Reply-To: <20170915100645.17999-7-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <AB7A04092CFCC94A9B6ED82F9830AA23@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

T24gRnJpLCAyMDE3LTA5LTE1IGF0IDE5OjA2ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gUmVhcnJhbmdlIHNkX3piY19zZXR1cCgpIHRvIGluY2x1ZGUgdXNlXzE2X2Zvcl9ydyBhbmQg
dXNlXzEwX2Zvcl9ydw0KPiBhc3NpZ25tZW50cyBhbmQgbW92ZSB0aGUgY2FsY3VsYXRpb24gb2Yg
c2RrcC0+em9uZV9zaGlmdCB0b2dldGhlcg0KPiB3aXRoIHRoZSBhc3NpZ25tZW50IG9mIHRoZSB2
ZXJpZmllZCB6b25lX2Jsb2NrcyB2YWx1ZSBpbg0KPiBzZF96YmNfY2hlY2tfem9uZV9zaXplKCku
DQoNCkJvdGggZnVuY3Rpb25zIGFyZSBjYWxsZWQgZnJvbSBpbnNpZGUgYmxvY2tfZGV2aWNlX29w
ZXJhdGlvbnMucmV2YWxpZGF0ZV9kaXNrLg0KSXNuJ3QgdGhhdCB0b28gbGF0ZSB0byBzZXQgdXNl
XzFbMDZdX2Zvcl9ydz8gU2hvdWxkbid0IGJvdGggYmUgc2V0IGp1c3QgYWZ0ZXINCnRoZSBzbGF2
ZV9hbGxvYyBjYWxsYmFjayBoYXMgYmVlbiBjYWxsZWQ/DQoNClRoYW5rcywNCg0KQmFydC4=
