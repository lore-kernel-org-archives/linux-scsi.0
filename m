From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] libata-scsi: better style in ata_msense_caching()
Date: Tue, 12 Jul 2016 13:20:52 -0400
Message-ID: <20160712172052.GL3190@htj.duckdns.org>
References: <5784f28c.c4d0620a.69372.3df2@mx.google.com>
 <20160712144824.GD3190@htj.duckdns.org>
 <CAGnHSEn-S1G55uNE9Wm9026Gny0f_Udu6F2auvDJksEKg3p_=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:35748 "EHLO
	mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbcGLRVB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2016 13:21:01 -0400
Content-Disposition: inline
In-Reply-To: <CAGnHSEn-S1G55uNE9Wm9026Gny0f_Udu6F2auvDJksEKg3p_=g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jul 13, 2016 at 12:20:40AM +0800, Tom Yan wrote:
> First of all "changeable" is the "version" of mode page requested by
> the user, while ata_id_*_enabled(id) are the value of setting reported
> by the device. I think it's ugly and confusing to check values of
> totally different nature "together".
> 
> The worse thing is, since we have implemented MODE SELECT /
> ata_mselect_caching() to serve exclusively the write cache feature,
> the difference in the two if-conditions made the code look even more
> arcane.
> 
> In my version, it is clear that when the user request the changeable
> mode page, the value for the WCE bit will always be "1" / "y", since
> we've made (only) it changeable in ata_mselect_caching(); and when the
> user request the current / default page, the values reflect the
> settings from the drive.

Can you please put the rationale in the patch description and repost?

Thanks.

-- 
tejun
