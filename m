From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: ahc_linux_map_seg() compile/style/data corruption fixes
Date: Wed, 14 May 2003 00:26:48 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <504652704.1052893608@aslan.scsiguy.com>
References: <20030514044934.GC29926@holomorphy.com> <498302704.1052893137@aslan.scsiguy.com> <20030514062134.GG2444@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030514062134.GG2444@holomorphy.com>
Content-Disposition: inline
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>> For the connoisseur, I've attached before/after disassemblies
>>> demonstrating that the if () whose failure is caused by (2) is a very,
>>> very, very real problem.
> 
> On Wed, May 14, 2003 at 12:18:57AM -0600, Justin T. Gibbs wrote:
>> This was obvious from code inspection.
> 
> ISTR a debate where it was claimed the constant would be implicitly
> promoted.

Promotion to long is all that is guaranteed at least up to C89.  I
don't think that C99 has changed this.  The use of ULL in the code
is required.

--
Justin
