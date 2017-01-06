From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Fri, 6 Jan 2017 21:16:25 +0530
Message-ID: <CAK=zhgqKxyfj2YM6r-F7A_prS8yh61j3otKk2+kTyEOEj4F=xw@mail.gmail.com>
References: <20161229080250.GA11605@infradead.org> <1483226343.2518.32.camel@linux.vnet.ibm.com>
 <1483280506.5512.1.camel@sandisk.com> <20170101.113311.417107391370623850.davem@davemloft.net>
 <1483292364.2345.5.camel@linux.vnet.ibm.com> <yq1y3ypgd7m.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1y3ypgd7m.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, jbaron@akamai.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, sagi@grimberg.me, Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Chaitra Basappa <chaitra.basappa@broadcom.com>, dledford@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 6, 2017 at 7:29 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "James" == James Bottomley <jejb@linux.vnet.ibm.com> writes:
>
> James> Now that I look at the reviews, each of the reviewers said what
> James> the correct thing to do was: return SAM_STAT_BUSY if SATL
> James> commands are outstanding like the spec says.  You all get
> James> negative brownie points for not insisting on a rework.
>
> James> Does this patch (compile tested only) fix the problems for
> James> everyone?
>
> I also like this approach better.
>
> Broadcom folks: Please comment and test.

Matin, We are fine with this patch. Can we rename function
'set_satl_pending()' name to '_scsih_set_satl_pending()' and can add
headers to this function.

other wise I am OK.

Acked-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

>
> --
> Martin K. Petersen      Oracle Linux Engineering
