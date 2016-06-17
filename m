From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] VMW_PVSCSI: Change to update maintainer details (name, email)
Date: Fri, 17 Jun 2016 13:11:21 +1000
Message-ID: <CAGRGNgXGxFdzE4fdEzr2iPRX0DPN9JNZcC8HNTt-jW6iNyMqnQ@mail.gmail.com>
References: <57634CBD.8000402@vmware.com> <CAGRGNgVK_xMmCQFHhhJ9E1frzTE--ivX1Po19O_qUjgYtuUK7A@mail.gmail.com>
 <1466128907097.81812@vmware.com> <CAGRGNgX=ec9m=zene34Lbp0Gn23jSjwyeqaGaG7jGYXnRy6hFg@mail.gmail.com>
 <1466130787.19647.100.camel@perches.com> <CAGRGNgXAgxMn9ChiVvcw+02ugEEKZh7WtXt2dLU-TegM-0_qKA@mail.gmail.com>
 <1466132688.19647.105.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466132688.19647.105.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Arvind Kumar <arvindkumar@vmware.com>, Jim Gill <jgill@vmware.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Joe,

On Fri, Jun 17, 2016 at 1:04 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2016-06-17 at 12:44 +1000, Julian Calaby wrote:
>> Hi Joe,
>
> rehi Julian.

(I always put a salutation on my emails and always finish them with
"Thanks," =) )

>> On Fri, Jun 17, 2016 at 12:33 PM, Joe Perches <joe@perches.com> wrote:
> []
>> > get_maintainer.pl also has a rarely used "--file-emails" option to
>> > scan for what appears to be email addresses in specific files.
>> >
>> > $ ./scripts/get_maintainer.pl  -f --file-emails drivers/scsi/vmw_pvscsi.c
>> > Arvind Kumar <arvindkumar@vmware.com> (maintainer:VMware PVSCSI driver,in file)
>> > VMware PV-Drivers <pv-drivers@vmware.com> (maintainer:VMware PVSCSI driver)
>> > "James E.J. Bottomley" <jejb@linux.vnet.ibm.com> (maintainer:SCSI SUBSYSTEM)
>> > "Martin K. Petersen" <martin.petersen@oracle.com> (maintainer:SCSI SUBSYSTEM)
>> > linux-scsi@vger.kernel.org (open list:VMware PVSCSI driver)
>> > linux-kernel@vger.kernel.org (open list)
>> >
>> > note the "in file" after Arvind's name
>> Didn't know this, however my point stands: the maintainer line in the
>> file is redundant if we find maintainers through MAINTAINERS or the
>> get_maintainer.pl script.
>
> Yes, I'm not suggesting anything else.  Jim's name
> should appear in the MAINTAINERS file somewhere.
>
> The question to me is whether or not Jim Gill is
> taking over the maintainership of the entire
> VMware PVSCSI driver or just a few files of it.

As I see it, he's taking over maintainership of all of it: it's only
files are drivers/scsi/vmw_pvscsi.[ch] AFAIK.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
