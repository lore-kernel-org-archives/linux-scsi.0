From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] [RESEND] aic7xxx: replace kmalloc/memset by kzalloc
Date: Tue, 24 Mar 2015 13:46:08 -0700
Message-ID: <5511CD10.6040709@free-electrons.com>
References: <94D0CD8314A33A4D9D801C0FE68B40295930E577@G4W3296.americas.hpqcorp.net> <1427041891-2694-1-git-send-email-michael.opdenacker@free-electrons.com> <550FB9BE.5010801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <550FB9BE.5010801@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, JBottomley@parallels.com
Cc: joe@perches.com, Elliott@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 03/22/2015 11:59 PM, Hannes Reinecke wrote:
> On 03/22/2015 05:31 PM, Michael Opdenacker wrote:
>> This replaces kmalloc + memset by a call to kzalloc
>> (or kcalloc when appropriate, which zeroes memory too)
>>
>> This also fixes one checkpatch.pl issue in the process.
>>
>> This improvement was suggested by "make coccicheck"
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

I'm sending a version that reverts the use of kcalloc() instead of
kzalloc(). For reasons I don't understand, I didn't see the end of
Robert Elliott's comment that the use of kcalloc() could prevent the
compiler from detecting an overflow.

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098
