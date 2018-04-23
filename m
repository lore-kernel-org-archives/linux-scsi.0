From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 0/6] scsi: handle special return codes for ABORTED
 COMMAND
Date: Mon, 23 Apr 2018 11:33:51 +0200
Message-ID: <1524476031.2075.24.camel@suse.com>
References: <20180417233511.6573-1-mwilck@suse.com>
         <yq1efj9h3l1.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1efj9h3l1.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-04-20 at 19:15 -0400, Martin K. Petersen wrote:
> 
> Much better, thanks for reworking this. Applied to 4.18/scsi-queue.

Thank you!

By the way, I've been wondering whether declaring blist_flags_t
__bitwise was a wise decision. blist_flags_t is kernel-internal, thus
endianness doesn't matter. OTOH, using __bitwise requires explicit
casts in many places, which may suppress warnings about integer size
mismatch and made me overlook some places where I had to change
"unsigned long" to "unsigned long long" in the first place
(in the submitted and applied version I think I caught them all).

Regards,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
