From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Add compat_ioctl to SG
Date: Tue, 18 Jan 2005 21:35:53 +1000
Message-ID: <41ECF499.9040501@torque.net>
References: <20050118110743.GD43344@muc.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:40425 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261276AbVARLfw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:35:52 -0500
In-Reply-To: <20050118110743.GD43344@muc.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Andi Kleen wrote:
<snip>
> @@ -1343,6 +1366,9 @@
>  	.write = sg_write,
>  	.poll = sg_poll,
>  	.ioctl = sg_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.ioctl = sg_compat_ioctl,
> +#endif

Andi,
Two initializations of ".ioctl" looks wrongs.
Comparing with the patch to sd should that be:
  +       .compat_ioctl = sg_compat_ioctl,
??


Doug Gilbert
