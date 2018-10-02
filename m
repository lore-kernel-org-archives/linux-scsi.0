From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Mon, 1 Oct 2018 23:55:22 -0700
Message-ID: <20181002065522.GA27010@flashbox>
References: <20180930205448.26205-1-natechancellor@gmail.com>
 <10b12992-3570-4646-374b-82cbd7276839@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <10b12992-3570-4646-374b-82cbd7276839@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Boaz Harrosh <ooo@electrozaur.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 01, 2018 at 06:16:32PM -0700, Bart Van Assche wrote:
> On 9/30/18 1:54 PM, Nathan Chancellor wrote:
> > diff --git a/include/scsi/osd_types.h b/include/scsi/osd_types.h
> > index 48e8a165e136..6b6fdcafa6cc 100644
> > --- a/include/scsi/osd_types.h
> > +++ b/include/scsi/osd_types.h
> > @@ -28,7 +28,7 @@ struct osd_obj_id {
> >   	osd_id id;
> >   };
> > -static const struct __weak osd_obj_id osd_root_object = {0, 0};
> > +static const struct osd_obj_id osd_root_object = {0, 0};
> 

Hi Bart,

> Structure definitions should occur in .c files instead of in header files
> especially if the header file is included from multiple source files. Please
> consider moving the definition of osd_root_object into a .c file.
> Additionally, zero initializers should be left out to minimize the size of
> object files.
> 

I'm perfectly happy to make this change in a v2 if necessary.

> Boaz, the most recent osd patch that is neither trivial nor treewide
> refactoring is six years old (51976a8c85ce ("[SCSI] osd_uld: Add osdname &
> systemid sysfs at scsi_osd class"). That suggests that nobody is using this
> driver anymore. Can this driver be removed from the kernel tree?
> 

However, this is certainly a better option if possible.

> Thanks,
> 
> Bart.

Thanks for the comments!
Nathan
