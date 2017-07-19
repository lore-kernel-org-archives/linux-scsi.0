From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 3/7] qla2xxx: Add command completion wq for error path
Date: Wed, 19 Jul 2017 20:46:45 +0000
Message-ID: <1500497204.2494.9.camel@wdc.com>
References: <20170719185151.8564-1-himanshu.madhani@cavium.com>
         <20170719185151.8564-4-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:56842 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755389AbdGSUrd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2017 16:47:33 -0400
In-Reply-To: <20170719185151.8564-4-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <0C8BB119FE1F934DA337A83EF905F890@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2017-07-19 at 11:51 -0700, Himanshu Madhani wrote:
> From: Duane Grigsby <duane.grigsby@cavium.com>

Hello Himanshu and Duane,

Too many drivers create workqueues for all kinds of purposes. Why is it
necessary to execute qla_nvme_io_work() on the context of a new workqueue?
If any of the existing system workqueues can be used please modify the patc=
h
accordingly. Otherwise please explain why it is necessary to introduce a ne=
w
workqueue.

Bart.=
