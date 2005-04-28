From: Andrew Morton <akpm@osdl.org>
Subject: Re: latest mpt-fusion oopses
Date: Thu, 28 Apr 2005 02:21:24 -0700
Message-ID: <20050428022124.73027770.akpm@osdl.org>
References: <20050428012151.2e207f47.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:54500 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261962AbVD1JV6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 05:21:58 -0400
In-Reply-To: <20050428012151.2e207f47.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

Andrew Morton <akpm@osdl.org> wrote:
>
> I guess I'll test this on x86 next.

It crashed, strangely.  See
http://www.zip.com.au/~akpm/linux/patches/stuff/dsc02504.jpg.

It appears to have jumped directly to address zero from handle_IRQ_event. 
Disabling CONFIG_PM didn't help.  No shared IRQs on this box.

Config is at http://www.zip.com.au/~akpm/linux/patches/stuff/config
