From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] megaraid_{mm,mbox}: updated
	fix-a-bug-in-reset-handler
Date: Wed, 03 May 2006 08:55:06 -0500
Message-ID: <1146664506.3346.3.camel@mulgrave.il.steeleye.com>
References: <890BF3111FB9484E9526987D912B261901BD27@NAMAIL3.ad.lsil.com>
	 <20060503062136.694e4d08.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:60040 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030212AbWECNza (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 May 2006 09:55:30 -0400
In-Reply-To: <20060503062136.694e4d08.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Ju, Seokmann" <Seokmann.Ju@lsil.com>, Seokmann.Ju@engenio.com, andre@linux-ide.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2006-05-03 at 06:21 -0700, Andrew Morton wrote:
> On Tue, 2 May 2006 14:04:06 -0600
> "Ju, Seokmann" <Seokmann.Ju@lsil.com> wrote:
> 
> > Is this patch accepted?
> 
> James is the scsi-patch-accepting guy.  I do pick up lots of patches which
> belong to subsystem maintainers (mainly because they're lossy...) but they
> still go through the subsytem maintainer.
> 
> > If not, can you please provide comment.
> 
> I don't appear to have a copy queued up, and I'm struggling a bit to
> identify the right patch (partly because your email client appears to
> support neither In-Reply-To: nor References:)

This is it, isn't it?

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=c005fb4fb2d23ba29ad21dee5042b2f8451ca8ba

James


