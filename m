From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2] sg: factor out sg_fill_request_table()
Date: Fri, 15 Sep 2017 14:26:47 +0000
Message-ID: <1505485606.2852.0.camel@wdc.com>
References: <1505477116-75013-1-git-send-email-hare@suse.de>
         <1505477116-75013-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:11312 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbdIOO1f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 10:27:35 -0400
In-Reply-To: <1505477116-75013-2-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <C398A2504221E5408576D2092AF0C0A3@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "security@kernel.org" <security@kernel.org>, "hch@lst.de" <hch@lst.de>, "dvyukov@google.com" <dvyukov@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "hare@suse.com" <hare@suse.com>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "glider@google.com" <glider@google.com>

T24gRnJpLCAyMDE3LTA5LTE1IGF0IDE0OjA1ICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IEZhY3RvciBvdXIgc2dfZmlsbF9yZXF1ZXN0X3RhYmxlKCkgZm9yIGJldHRlciByZWFkYWJp
bGl0eS4NCg0KUmV2aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YmFydC52YW5hc3NjaGVAd2Rj
LmNvbT4NCg0K
