From: Andrew Morton <akpm@osdl.org>
Subject: Re: PROBLEM: LSIFC909 mpt card fails to recognize devices
Date: Thu, 4 Jan 2007 16:59:22 -0800
Message-ID: <20070104165922.137c6df9.akpm@osdl.org>
References: <1167955606.5133.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:40837 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965118AbXAEA7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jan 2007 19:59:43 -0500
In-Reply-To: <1167955606.5133.13.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Justin Rosander <myrddinemrys@neo.rr.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 04 Jan 2007 19:06:46 -0500
Justin Rosander <myrddinemrys@neo.rr.com> wrote:

> Please forward this to the appropriate maintainer.  Thank you.
> 
> [1.] One line summary of the problem:    My fibre channel drives fail to
> be recognized by my LSIFC909 card. 

Please send the output of `lspci -vn'
