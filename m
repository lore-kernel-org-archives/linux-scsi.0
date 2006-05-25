From: "Stephen C. Tweedie" <sct@redhat.com>
Subject: Re: resizing LUN (not file system) while the file system (ext3) is
	online
Date: Thu, 25 May 2006 12:45:38 +0100
Message-ID: <1148557538.5115.21.camel@sisko.sctweedie.blueyonder.co.uk>
References: <043001c67fba$5ff05b70$6400a8c0@andreyT43>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:31629 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S965119AbWEYLpn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 07:45:43 -0400
In-Reply-To: <043001c67fba$5ff05b70$6400a8c0@andreyT43>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: admitriev@mentora.com
Cc: linux-scsi@vger.kernel.org, Stephen Tweedie <sct@redhat.com>

Hi,

On Thu, 2006-05-25 at 01:16 -0400, Andrey Dmitriev wrote:

> I understand that ext3 doesn't support online expansion (not in RedHat ES/AS
> at least)

Yes it does, and it should work fine in RHEL-4, or FC-3 or later.  Ted
just integrated the online resize user-space tools into upstream
e2fsprogs a couple of months ago, and only this week he turned on the
resize inode feature in mke2fs by default.

> However, just because the disk array can be done online that does not mean
> the application layer can handle online expansion (some file systems can
> handle online expansion, currently ext3 cannot)."

Out-of-date information. :-)

Cheers,
 Stephen


