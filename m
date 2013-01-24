From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention handling
Date: Thu, 24 Jan 2013 07:38:11 -0700
Message-ID: <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
	<CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com>
	<51011D2E.305@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:59530 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3AXOiM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jan 2013 09:38:12 -0500
Received: by mail-ob0-f177.google.com with SMTP id wc20so8722404obb.8
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jan 2013 06:38:12 -0800 (PST)
In-Reply-To: <51011D2E.305@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On Thu, Jan 24, 2013 at 4:38 AM, Hannes Reinecke <hare@suse.de> wrote:
> As for AEN, does iSCSI _do_ AEN? I thought it got removed ...
>
> If it does, though, it should schedule an event on its own whenever an AER
> is received. The same goes for LLDDs with vendor-specific AENs; thinking of
> megaraid_sas here ...

Let me ask this another way. SAN users expect that the LUN list at the
initiator side gets updated automatically after a SAN configuration
change. How should a SAN system communicate to a SCSI initiator that
the LUN list has been changed ? Some FC SAN systems send a LIP after a
configuration change to force the initiator to rescan LUNs. But how to
inform the initiator about a LUN change for other SCSI protocols ? I'm
not sure that it is even possible to report such a change via sense
data in case a SAN user first removes all LUNs and after that change
adds one or more LUNs.

Bart.
