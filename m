From: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] git scsi misc include fix
Date: Mon, 15 Oct 2007 18:24:39 -0700
Message-ID: <20071015182439.3fd5f25f.pj@sgi.com>
References: <20071014053508.30836.69658.sendpatchset@jackhammer.engr.sgi.com>
	<1192491330.14524.16.camel@localhost.localdomain>
	<20071015170842.9cfe4846.pj@sgi.com>
	<1192496837.14524.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56425 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755162AbXJPBYn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 21:24:43 -0400
In-Reply-To: <1192496837.14524.26.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@linux-foundation.org, willy@linux.intel.com, linux-kernel@vger.kernel.org, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, bharrosh@panasas.com

James wrote:
> In that case, the correct fix
> is actually to move the scatterlist include from scsi_error.c (where the
> scatterlist was originally used locally) into scsi_eh.h, like this.

I suspect you're correct, yes.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
