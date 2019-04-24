From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v2 26/79] docs: powerpc: convert docs to ReST and rename
 to *.rst
Date: Wed, 24 Apr 2019 11:15:45 +1000
Message-ID: <5114a435-030a-8c2c-885d-f5e053f9749b@au1.ibm.com>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
 <dbbfc37a221aa1a1320bdfbb34f593d8a76f643d.1555938376.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dbbfc37a221aa1a1320bdfbb34f593d8a76f643d.1555938376.git.mchehab+samsung@kernel.org>
Content-Language: en-AU
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Bjorn Helgaas <bhelgaas@google.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Frederic Barrat <fbarrat@linux.ibm.com>, "Manoj N. Kumar" <manoj@linux.ibm.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, Uma Krishnan <ukrishn@linux.ibm.com>, Russell Currey <ruscur@russell.cc>, Sam Bobroff <sbobroff@linux.ibm.com>, Oliver O'Halloran <oohall@gmail.com>, Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kern
List-Id: linux-scsi@vger.kernel.org

On 22/4/19 11:27 pm, Mauro Carvalho Chehab wrote:
> Convert docs to ReST and add them to the arch-specific
> book.
> 
> The conversion here was trivial, as almost every file there
> was already using an elegant format close to ReST standard.
> 
> The changes were mostly to mark literal blocks and add a few
> missing section title identifiers.
> 
> One note with regards to "--": on Sphinx, this can't be used
> to identify a list, as it will format it badly. This can be
> used, however, to identify a long hyphen - and "---" is an
> even longer one.
> 
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>  # cxl

Minor possible improvement below, otherwise compiled output looks very nice.

> diff --git a/Documentation/powerpc/cxl.txt b/Documentation/powerpc/cxl.rst
> similarity index 95%
> rename from Documentation/powerpc/cxl.txt
> rename to Documentation/powerpc/cxl.rst
> index c5e8d5098ed3..99e704afb09d 100644
> --- a/Documentation/powerpc/cxl.txt
> +++ b/Documentation/powerpc/cxl.rst
> @@ -1,3 +1,4 @@
> +====================================
>   Coherent Accelerator Interface (CXL)
>   ====================================
>   
> @@ -21,6 +22,8 @@ Introduction
>   Hardware overview
>   =================
>   
> +    ::
> +
>            POWER8/9             FPGA
>          +----------+        +---------+
>          |          |        |         |
> @@ -59,14 +62,16 @@ Hardware overview
>       the fault. The context to which this fault is serviced is based on
>       who owns that acceleration function.
>   
> -    POWER8 <-----> PSL Version 8 is compliant to the CAIA Version 1.0.
> -    POWER9 <-----> PSL Version 9 is compliant to the CAIA Version 2.0.
> +    - POWER8 <------> PSL Version 8 is compliant to the CAIA Version 1.0.
> +    - POWER9 <------> PSL Version 9 is compliant to the CAIA Version 2.0.
> +

This could probably be changed to "POWER8 and PSL Version 8 are 
compliant" or something like that to avoid the ASCII art arrows turning 
into dashes. Happy to pick this up myself if I ever get around to 
revising the rest of the documentation.


-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
