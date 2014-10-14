From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Sparc ESP problem with blk-mq
Date: Tue, 14 Oct 2014 08:38:18 -0600
Message-ID: <543D355A.3030605@kernel.dk>
References: <alpine.LRH.2.11.1410140102230.18488@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1410140102230.18488@adalberg.ut.ee>
Sender: sparclinux-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

(resent with correct linux-scsi address)

On 2014-10-13 16:07, Meelis Roos wrote:
> I turned on blk-mq for all my test machines today and got a failure from
> Sun Ultra 1 with Sparc ESP SCSI (dmesg below). Booting with
> scsi_mod.use_blk_mq=0 fixes the problem. The problem is reproducible.

[snip]

> [   63.244199] esp: esp0, regs[1ffe8800000:1ffe8400000] irq[10]
> [   63.310055] esp: esp0 is a FAS100A, 40 MHz (ccf=0), SCSI ID 7
> [   66.383895] scsi host0: esp
> [  148.437533] scsi 0:0:0:0: timing out command, waited 82s
> [  149.674112] ESP: unexpected IREG 40
> [  149.713889] esp: esp0: Dumping command log
> [  149.762847] esp: esp0: ent[14] CMD val[01] sreg[93] seqreg[04] sreg2[00] ireg[18] ss[00] event[0d]

[snip]

Christoph, any idea on this? The command just times out, for some 
reason. Only thing I could think of was related to perhaps missing 
bouncing or similar, but I don't think that's the case. But the hba must 
not like the request somehow. Or perhaps it sets up the wrong number of 
segments.

-- 
Jens Axboe

