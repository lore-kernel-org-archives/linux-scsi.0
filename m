From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen-scsifront: Add a missing call to kfree
Date: Tue, 22 Nov 2016 06:19:49 +0100
Message-ID: <a30e7c39-332f-4012-5e43-3016d9fc4667@suse.com>
References: <20161119182256.9081-1-lambert.quentin@gmail.com>
 <1320a162-dc36-5833-a746-367134dae5e7@suse.com>
 <yq1twb0yygf.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1twb0yygf.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Quentin Lambert <lambert.quentin@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 22/11/16 04:40, Martin K. Petersen wrote:
>>>>>> "Juergen" == Juergen Gross <jgross@suse.com> writes:
> 
> Juergen,
> 
> Juergen> On 19/11/16 19:22, Quentin Lambert wrote:
>>> Most error branches following the call to kmalloc contain a call to
>>> kfree. This patch add these calls where they are missing.
>>>
>>> This issue was found with Hector.
>>>
>>> Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
> 
> Juergen> Nice catch. I think this will need some more work, I'll do a
> Juergen> follow-on patch.
> 
> Juergen> Reviewed-by: Juergen Gross <jgross@suse.com>
> 
> Are you taking this patch through the Xen tree or should I queue it up?

I'm taking it through the xen tree, thanks.


Juergen
