From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] xen-scsifront: Add a missing call to kfree
Date: Mon, 21 Nov 2016 22:40:00 -0500
Message-ID: <yq1twb0yygf.fsf@sermon.lab.mkp.net>
References: <20161119182256.9081-1-lambert.quentin@gmail.com>
        <1320a162-dc36-5833-a746-367134dae5e7@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1320a162-dc36-5833-a746-367134dae5e7@suse.com> (Juergen Gross's
        message of "Mon, 21 Nov 2016 07:01:36 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: Quentin Lambert <lambert.quentin@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Juergen" == Juergen Gross <jgross@suse.com> writes:

Juergen,

Juergen> On 19/11/16 19:22, Quentin Lambert wrote:
>> Most error branches following the call to kmalloc contain a call to
>> kfree. This patch add these calls where they are missing.
>> 
>> This issue was found with Hector.
>> 
>> Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>

Juergen> Nice catch. I think this will need some more work, I'll do a
Juergen> follow-on patch.

Juergen> Reviewed-by: Juergen Gross <jgross@suse.com>

Are you taking this patch through the Xen tree or should I queue it up?

-- 
Martin K. Petersen	Oracle Linux Engineering
