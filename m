From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [LSF/MM TOPIC] LIO/SCST Merger
Date: Thu, 28 Jan 2016 07:34:48 -0800
Message-ID: <56AA3518.8060507@sandisk.com>
References: <56A9043B.7030207@sandisk.com>
 <1453963019.6746.244.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0080.outbound.protection.outlook.com ([157.56.111.80]:38016
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755592AbcA1Pex (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 10:34:53 -0500
In-Reply-To: <1453963019.6746.244.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/27/16 22:37, Nicholas A. Bellinger wrote:
> [ ... ]

Hi Nic,

Since in the most recent years all my communication to you was neutral 
and professional in tone it is not clear to me why you wrote such a 
misleading and unfair e-mail. Anyway, I would like to point out that the 
following information is missing from your e-mail:
- That last year the storage HBA vendors and Linux distributor
   representatives who attended my session about this topic where
   unanimously enthusiastic about my proposal. You were the only
   attendee who was not (yet?) enthusiast.
- That I am working on sending the ib_srpt patches upstream you
   referred to in your e-mail and that a first version of that patch
   series has already been posted on the linux-rdma mailing list.
- Although five years ago some SCST users switched to LIO, recently
   several LIO users switched back to SCST because the latter is still
   more stable and easier to configure than LIO. In other words, it is
   in your own interest to help the LIO patches upstream that I posted
   recently.
- One of the reasons that the LIO core patches I'm working on are not
   yet upstream is because of how long it takes before you as a
   maintainer provide feedback. The first version of my patch to make
   ABORT and LUN RESET handling synchronous was posted on October 12,
   2015. It took until November 15, 2015 before I received the first
   feedback from you for that patch.

Bart.
