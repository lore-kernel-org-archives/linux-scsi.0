From: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 11 Dec 2003 20:18:34 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312112018.34753.krmurthy@cisco.com>
References: <200310231734.10263.krmurthy@cisco.com> <200312041800.55663.krmurthy@cisco.com> <1070594036.1603.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:59718 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S265056AbTLKOsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2003 09:48:45 -0500
In-Reply-To: <1070594036.1603.34.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, hotplug <linux-hotplug-devel@lists.sourceforge.net>, davmyers@cisco.com, "Scott M. Ferris" <sferris@acm.org>

Hi,
	Thanks for the clarification. As you pointed out, 
upon establishing a session with iSCSI target 
OR
upon getting notified of Lun(s) additio/deletion.
we will inform hotplug and let it initiate a scan(re) of that target thru 
sysfs.  Please provide the wrapper in SCSI layer.

Thanx
N.C.Krishna Murthy

On Friday 05 Dec 2003 9:03 pm, James Bottomley wrote:
>
> Well, a hotplug event feeds certain information into the environment
> when it triggers the call.  All we really need is a wrapper in SCSI to
> add the SCSI information to the environment and trigger the event in a
> generic fashion.
>
> James
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
