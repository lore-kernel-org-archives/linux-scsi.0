From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: ahc_linux_map_seg() compile/style/data corruption fixes
Date: Tue, 13 May 2003 23:21:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030514062134.GG2444@holomorphy.com>
References: <20030514044934.GC29926@holomorphy.com> <498302704.1052893137@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from holomorphy.com ([66.224.33.161]:57792 "EHLO holomorphy")
	by vger.kernel.org with ESMTP id S262057AbTENGIw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 02:08:52 -0400
Content-Disposition: inline
In-Reply-To: <498302704.1052893137@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>> For the connoisseur, I've attached before/after disassemblies
>> demonstrating that the if () whose failure is caused by (2) is a very,
>> very, very real problem.

On Wed, May 14, 2003 at 12:18:57AM -0600, Justin T. Gibbs wrote:
> This was obvious from code inspection.

ISTR a debate where it was claimed the constant would be implicitly
promoted.


I got your other post too, and am fine with your patch to fix up the
compile errors.


-- wli
