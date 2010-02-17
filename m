From: Oliver Neukum <oliver@neukum.org>
Subject: Re: question on detecting a media change
Date: Wed, 17 Feb 2010 14:05:10 +0100
Message-ID: <201002171405.10640.oliver@neukum.org>
References: <201002122301.31366.oliver@neukum.org> <4B76D66D.9050602@interlog.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:52969 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab0BQNFJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 08:05:09 -0500
In-Reply-To: <4B76D66D.9050602@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

Am Samstag, 13. Februar 2010 17:42:21 schrieb Douglas Gilbert:
> To detect the media has changed something at a higher
> level needed to get a unique key associated with the
> media before the Unit attention then generate another
> unique key from the media after the Unit attention.
> The comparison tells you the answer.

Thanks. That's not the answer I would have liked, but it'll
have to do.

	Thanks
		Oliver
