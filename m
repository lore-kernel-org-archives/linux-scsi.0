From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen-scsifront: Add a missing call to kfree
Date: Tue, 6 Dec 2016 06:45:56 +0100
Message-ID: <9aef1d68-4755-e87d-4919-fb8ca4bea4fb@suse.com>
References: <20161119182256.9081-1-lambert.quentin@gmail.com>
 <1320a162-dc36-5833-a746-367134dae5e7@suse.com>
 <20161205205348.GA31465@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20161205205348.GA31465@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Quentin Lambert <lambert.quentin@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/12/16 21:53, Dan Carpenter wrote:
> On Mon, Nov 21, 2016 at 07:01:36AM +0100, Juergen Gross wrote:
>> On 19/11/16 19:22, Quentin Lambert wrote:
>>> Most error branches following the call to kmalloc contain
>>> a call to kfree. This patch add these calls where they are
>>> missing.
>>>
>>> This issue was found with Hector.
>>>
>>> Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
>>
>> Nice catch. I think this will need some more work, I'll do a
>> follow-on patch.
>>
> 
> The error handling is really weird.  Could you send your follow on to
> this thread?

I did:

https://lkml.org/lkml/2016/12/2/17


Juergen

