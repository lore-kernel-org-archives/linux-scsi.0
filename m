From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 05/19] scsi_setup_fs_cmnd(): Call scsi_req_init() instead
 of open-coding it
Date: Thu, 24 Aug 2017 16:17:00 +0000
Message-ID: <1503591419.2702.10.camel@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
         <20170823214009.15015-6-bart.vanassche@wdc.com>
         <20170824090514.GE19886@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:57764 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753210AbdHXQRo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2017 12:17:44 -0400
In-Reply-To: <20170824090514.GE19886@lst.de>
Content-Language: en-US
Content-ID: <2823A0101744B4438582485047490CD0@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>

T24gVGh1LCAyMDE3LTA4LTI0IGF0IDExOjA1ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gSSBkb24ndCByZWFsbHkgc2VlIHRoZSBwb2ludCBvZiBkb2luZyBtb3JlIHdvcmsgaW4g
ZXhhY3RseSB0aGUgc2FtZQ0KPiBhbW91bnQgb2YgY29kZSBoZXJlLCBlc3BlY2lhbGx5IGdpdmVu
IHRoYXQgdGhpcyBpcyB0aGUgZmFzdCBwYXRoLg0KPiANCj4gRG8geW91IG5lZWQgdGhpcyBmb3Ig
YW55IGZ1dHVyZSBwYXRjaGVzPw0KDQpIZWxsbyBDaHJpc3RvcGgsDQoNCkkgd2lsbCBkcm9wIHRo
aXMgcGF0Y2guDQoNCkJhcnQu
