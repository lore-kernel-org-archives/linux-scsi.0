From: Eric Moore <eric.moore@lsil.com>
Subject: Re: PROBLEM: LSIFC909 mpt card fails to recognize devices
Date: Thu, 4 Jan 2007 20:55:26 -0700
Message-ID: <20070105035526.GA14185@lsil.com>
References: <1167955606.5133.13.camel@localhost> <20070104165922.137c6df9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:44100 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030302AbXAEDx5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jan 2007 22:53:57 -0500
Content-Disposition: inline
In-Reply-To: <20070104165922.137c6df9.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Justin Rosander <myrddinemrys@neo.rr.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jan 04, 2007 at 04:59:22PM -0800, Andrew Morton wrote:
> On Thu, 04 Jan 2007 19:06:46 -0500
> Justin Rosander <myrddinemrys@neo.rr.com> wrote:
> 
> > Please forward this to the appropriate maintainer.  Thank you.
> > 
> > [1.] One line summary of the problem:    My fibre channel drives fail to
> > be recognized by my LSIFC909 card. 
> 
> Please send the output of `lspci -vn'
> -

Recompile the driver with MPT_DEBUG_INIT enabled in the driver Makefile,
and repost the output.

Eric Moore

