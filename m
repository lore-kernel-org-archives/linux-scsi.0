From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: SYNCHRONIZE_CACHE command is not retried
Date: Tue, 4 May 2010 14:53:11 +0200
Message-ID: <201005041453.11308.bernd.schubert@fastmail.fm>
References: <4BE011AF.7010509@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54067 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759732Ab0EDNCg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2010 09:02:36 -0400
In-Reply-To: <4BE011AF.7010509@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tuesday 04 May 2010, Hannes Reinecke wrote:
> Hi all,
> 
> I'm facing an issue here where the 'SYNCHRONIZE CACHE' command is not
>  retried:


Interesting that suddenly several people run into it, when I already noticed 
long ago. Hmm, you work for Suse, maybe you now got the ticket I have asked 
our customer about to open for their SLES system? ;)

Recent discussion is here:
http://kerneltrap.org/mailarchive/linux-scsi/2010/4/19/6884638

Sorry, I didn't have time yet to update the patch there.


Cheers,
Bernd
