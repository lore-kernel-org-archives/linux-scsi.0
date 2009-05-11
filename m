From: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: Next May 11 : BUG during scsi initialization
Date: Mon, 11 May 2009 22:29:51 +0530
Message-ID: <4A085987.7070706@in.ibm.com>
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au>
	<4A081002.4050802@in.ibm.com>
	<20090511115233.GB8112@parisc-linux.org>
	<4A081437.7000409@in.ibm.com>
	<20090511122135.GC8112@parisc-linux.org>
	<4A08502B.9040001@in.ibm.com>
	<20090511162511.GG8112@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@ozlabs.org>
In-Reply-To: <20090511162511.GG8112@parisc-linux.org>
List-Unsubscribe: <https://ozlabs.org/mailman/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@ozlabs.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Nick Piggin <npiggin@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi <linux-scsi@vger.kernel.org>, chinang.ma@intel.com, linuxppc-dev@ozlabs.org, Pekka Enberg <penberg@cs.helsinki.fi>, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, May 11, 2009 at 09:49:55PM +0530, Sachin Sant wrote:
>   
>> Yeah so the problem seems to be with SLQB. I was able to boot Next 11 with
>> SLUB on the same machine.
>>     
>
> Is it 100% reproducable with SLQB?  Our errors were fairly hard to tickle
> on demand.
>
>   
Yes. I am able to recreate this during every single reboot. I just 
tested few older next
releases (May 6th, 7th and 8th)as well and was able to recreate this 
issue with every release.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------
