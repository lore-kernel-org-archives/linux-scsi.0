From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: ahc_linux_map_seg() compile/style/data corruption fixes
Date: Tue, 13 May 2003 23:28:31 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030514062831.GH2444@holomorphy.com>
References: <20030514044934.GC29926@holomorphy.com> <498302704.1052893137@aslan.scsiguy.com> <20030514062134.GG2444@holomorphy.com> <504652704.1052893608@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <504652704.1052893608@aslan.scsiguy.com>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 14, 2003 at 12:18:57AM -0600, Justin T. Gibbs wrote:
>>> This was obvious from code inspection.

>> ISTR a debate where it was claimed the constant would be implicitly
>> promoted.

On Wed, May 14, 2003 at 12:26:48AM -0600, Justin T. Gibbs wrote:
> Promotion to long is all that is guaranteed at least up to C89.  I
> don't think that C99 has changed this.  The use of ULL in the code
> is required.

I thought they were wrong too, hence the patch. =)


-- wli
