From: Doug Ledford <dledford@redhat.com>
Subject: Re: [HELP] qla2200 driver over 4G memory
Date: Thu, 20 Jun 2002 16:21:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020620162129.F9181@redhat.com>
References: <20020620141813.B9181@redhat.com> <Pine.BSF.4.21.0206201145290.31972-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.BSF.4.21.0206201145290.31972-100000@beppo>; from mjacob@feral.com on Thu, Jun 20, 2002 at 11:46:05AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <mjacob@feral.com>
Cc: miyoshi@hpc.bs1.fc.nec.co.jp, ctierney@hpti.com, linux-scsi@vger.kernel.org

On Thu, Jun 20, 2002 at 11:46:05AM -0700, Matthew Jacob wrote:
> 
> 
> Hah. The qlogic documentation is clear- you can't span 4GB segments when you
> use 64 bit SCSI requests.

Hehehe...I would have said that instead of guessing that if I actually had 
docs ;-)

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
