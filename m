From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [Fwd: Posting error: Linux-iSCSI.org Target Development]
Date: Thu, 29 Jan 2009 13:55:03 +0200
Message-ID: <49819917.3050001@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090204010100000109030404"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:1855 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752009AbZA2LzD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2009 06:55:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------090204010100000109030404
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Nicholas!

Please don't cross post to a members only mailing-list.
One might be subscribed to one mailing-list and not
the other. See mail below.

Boaz

-------- Original Message --------
Subject: Posting error: Linux-iSCSI.org Target Development
Date: Thu, 29 Jan 2009 11:46:55 +0000
From: noreply@googlegroups.com
To: bharrosh@panasas.com

 Hello bharrosh@panasas.com,

We're writing to let you know that the group that you tried to contact
(linux-iscsi-target-dev) either doesn't exist, or you don't have permission to
post to it. There are a few possible reasons why this happened:

 * You might have spelled or formatted the group name incorrectly.
 * The owner of the group removed this group, so there's nobody there to 
contact.
 * You may need to join the group before being allowed to post.
 * This group may not be open to posting.

 If you have questions about this or any other group, please visit the Google 
Groups Help Center at http://groups.google.com/support.

 Thanks, and we hope you'll continue to enjoy Google Groups.

 The Google Groups Team


--------------090204010100000109030404
Content-Type: message/rfc822;
 name="ForwardedMessage.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ForwardedMessage.eml"

Received: by 10.114.158.3 with SMTP id g3mr962wae.3.1233229615195; Thu, 29 Jan 2009 03:46:55 -0800 (PST)
Return-Path: <bharrosh@panasas.com>
Received: from laguna.int.panasas.com (gw-ca.panasas.com [66.104.249.162]) by mx.google.com with ESMTP id m37si3300913waf.2.2009.01.29.03.46.54; Thu, 29 Jan 2009 03:46:54 -0800 (PST)
Received-SPF: pass (google.com: best guess record for domain of bharrosh@panasas.com designates 66.104.249.162 as permitted sender) client-ip=66.104.249.162;
Authentication-Results: mx.google.com; spf=pass (google.com: best guess record for domain of bharrosh@panasas.com designates 66.104.249.162 as permitted sender) smtp.mail=bharrosh@panasas.com
Received: from daytona.int.panasas.com ([172.17.28.41]) by laguna.int.panasas.com with Microsoft SMTPSVC(6.0.3790.3959); Thu, 29 Jan 2009 03:46:50 -0800
Received: from bh-buildlin2.bhalevy.com ([172.17.28.136]) by daytona.int.panasas.com with Microsoft SMTPSVC(6.0.3790.3959); Thu, 29 Jan 2009 06:46:48 -0500
Message-ID: <4981972A.2090801@panasas.com>
Date: Thu, 29 Jan 2009 13:46:50 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>,  linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] [Linux/SCSI]: Change RECEIVE_CREDENTIAL to	VLC_SA_RECEIVE_CREDENTIAL
References: <1233093749.6442.97.camel@haakon2.linux-iscsi.org> <1233094236.6442.110.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1233094236.6442.110.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-Path: bharrosh@panasas.com
X-OriginalArrivalTime: 29 Jan 2009 11:46:48.0864 (UTC) FILETIME=[44DF5A00:01C98207]


Nicholas A. Bellinger wrote:
> Hi James,
> 
> Let me know if you need a fresh respin of this patch..  According to
> spc4r17 section D.3.5, VLC_SA_RECEIVE_CREDENTIAL is the only
> VARIABLE_LENGTH_CMD defined Service ACtion..
> 
> --nab

Not accurate. See file include/scsi/osd_protocol.h in the scsi-misc
git-tree master branch. The complete OSD command set is VARIABLE_LENGTH_CMD
based. There must be others as well

Boaz


--------------090204010100000109030404--
