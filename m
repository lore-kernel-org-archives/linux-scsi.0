From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: Question on SMP
Date: Thu, 11 Jul 2002 09:01:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF17661460.710343AA-ON87256BF3.0057EBA5@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Subrahmanya Sastry K V <skotra@npd.hcltech.com>
Cc: ilugc@aero.iitm.ernet.in, linux-scsi@vger.kernel.org


>( Statically disabling the SMP support in the kernel config file
>   and recompiling the kernel is one way. Any clues on
>    how to achieve it dynamically?)

A slightly more dynamic way is the kernel boot parameter maxcpus=1 .



