From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [RESEND] wd719x: add missing .module to wd719x_template
Date: Thu, 12 Feb 2015 07:09:03 -0800
Message-ID: <1423753743.2147.4.camel@HansenPartnership.com>
References: <1423485501-5992-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33173 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755302AbbBLPJF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2015 10:09:05 -0500
In-Reply-To: <1423485501-5992-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2015-02-09 at 13:38 +0100, Ondrej Zary wrote:
> wd719x_template is missing the .module field, causing module refcount
> not to work, allowing to rmmod the driver while in use (mounted filesystem),
> causing an oops.
> 
> Set .module to THIS_MODULE to fix the problem.

This requires a cc to stable, doesn't it?

James


