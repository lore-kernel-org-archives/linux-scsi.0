From: Andrew Morton <akpm@osdl.org>
Subject: Re: variable used before set
Date: Tue, 28 Jun 2005 03:58:53 -0700
Message-ID: <20050628035853.3470e420.akpm@osdl.org>
References: <BAY19-F35B8A38C4A94BA62F2B5139CE10@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19158 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261305AbVF1LCp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2005 07:02:45 -0400
In-Reply-To: <BAY19-F35B8A38C4A94BA62F2B5139CE10@phx.gbl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: d binderman <dcb314@hotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


(Add linux-scsi)

"d binderman" <dcb314@hotmail.com> wrote:
>
> Hello there,
> 
> I just tried to compile the Linux Kernel version 2.6.11.12
> with the most excellent Intel C compiler. It said
> 
> drivers/scsi/pcmcia/aha152x_stub.c(313): remark #592: variable "tmp" is used 
> before its value is set
>         tmp.device->host = info->host;
>         ^
> 
> This is clearly broken code, since the field tmp.device has not been
> initialised, and so isn't pointing to anything.
> 
> Suggest code rework.

Yup, that will crash.
