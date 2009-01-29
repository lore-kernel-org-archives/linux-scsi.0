From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/4] [Linux/SCSI]: Change RECEIVE_CREDENTIAL to	VLC_SA_RECEIVE_CREDENTIAL
Date: Thu, 29 Jan 2009 13:46:50 +0200
Message-ID: <4981972A.2090801@panasas.com>
References: <1233093749.6442.97.camel@haakon2.linux-iscsi.org> <1233094236.6442.110.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:4358 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751988AbZA2Lqu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2009 06:46:50 -0500
In-Reply-To: <1233094236.6442.110.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

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
