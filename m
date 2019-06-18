From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v4 19/28] docs: powerpc: convert docs to ReST and rename to *.rst
Date: Tue, 18 Jun 2019 22:39:32 +1000
Message-ID: <87blyvoynv.fsf@concordia.ellerman.id.au>
References: <cover.1560361364.git.mchehab+samsung@kernel.org> <63560c1ee7174952e148a353840a17969fe0be2d.1560361364.git.mchehab+samsung@kernel.org> <20190614143635.3aff154d@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190614143635.3aff154d@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Linas Vepstas <linasvepstas@gmail.com>, Russell Currey <ruscur@russell.cc>, Sam Bobroff <sbobroff@linux.ibm.com>, Oliver O'Halloran <oohall@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Frederic Barrat <fbarrat@linux.ibm.com>, Andrew Donnellan <ajd@linux.ibm.com>, "Manoj N. Kumar" <manoj@linux.ibm.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, Uma Krishnan <ukrishn@linux.ibm.com>, Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, linux-pci@vger.
List-Id: linux-scsi@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> writes:
> On Wed, 12 Jun 2019 14:52:55 -0300
> Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
>
>> Convert docs to ReST and add them to the arch-specific
>> book.
>> 
>> The conversion here was trivial, as almost every file there
>> was already using an elegant format close to ReST standard.
>> 
>> The changes were mostly to mark literal blocks and add a few
>> missing section title identifiers.
>> 
>> One note with regards to "--": on Sphinx, this can't be used
>> to identify a list, as it will format it badly. This can be
>> used, however, to identify a long hyphen - and "---" is an
>> even longer one.
>> 
>> At its new index.rst, let's add a :orphan: while this is not linked to
>> the main index.rst file, in order to avoid build warnings.
>> 
>> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>> Acked-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com> # cxl
>
> This one fails to apply because ...
>
> [...]
>
>> diff --git a/Documentation/PCI/pci-error-recovery.rst b/Documentation/PCI/pci-error-recovery.rst
>> index 83db42092935..acc21ecca322 100644
>> --- a/Documentation/PCI/pci-error-recovery.rst
>> +++ b/Documentation/PCI/pci-error-recovery.rst
>> @@ -422,3 +422,24 @@ That is, the recovery API only requires that:
>>     - drivers/net/cxgb3
>>     - drivers/net/s2io.c
>>     - drivers/net/qlge
>> +
>> +>>> As of this writing, there is a growing list of device drivers with
>> +>>> patches implementing error recovery. Not all of these patches are in
>> +>>> mainline yet. These may be used as "examples":
>> +>>>
>> +>>> drivers/scsi/ipr
>> +>>> drivers/scsi/sym53c8xx_2
>> +>>> drivers/scsi/qla2xxx
>> +>>> drivers/scsi/lpfc
>> +>>> drivers/next/bnx2.c
>> +>>> drivers/next/e100.c
>> +>>> drivers/net/e1000
>> +>>> drivers/net/e1000e
>> +>>> drivers/net/ixgb
>> +>>> drivers/net/ixgbe
>> +>>> drivers/net/cxgb3
>> +>>> drivers/net/s2io.c
>> +>>> drivers/net/qlge  
>
> ...of this, which has the look of a set of conflict markers that managed
> to get committed...?

I don't think so.

There's some other uses of >>> in that file, eg about line 162:

  >>> The current powerpc implementation assumes that a device driver will
  >>> *not* schedule or semaphore in this routine; the current powerpc
  >>> implementation uses one kernel thread to notify all devices;
  >>> thus, if one device sleeps/schedules, all devices are affected.
  >>> Doing better requires complex multi-threaded logic in the error
  >>> recovery implementation (e.g. waiting for all notification threads
  >>> to "join" before proceeding with recovery.)  This seems excessively
  >>> complex and not worth implementing.


So it's just an odd choice of emphasis device I think.

cheers
