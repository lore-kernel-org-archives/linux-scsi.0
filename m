From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [HELP] qla2200 driver over 4G memory
Date: Thu, 20 Jun 2002 13:35:40 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0206201334360.31972-100000@beppo>
References: <20020620162129.F9181@redhat.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020620162129.F9181@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: miyoshi@hpc.bs1.fc.nec.co.jp, ctierney@hpti.com, linux-scsi@vger.kernel.org

On Thu, 20 Jun 2002, Doug Ledford wrote:

> On Thu, Jun 20, 2002 at 11:46:05AM -0700, Matthew Jacob wrote:
> > 
> > 
> > Hah. The qlogic documentation is clear- you can't span 4GB segments when you
> > use 64 bit SCSI requests.
> 
> Hehehe...I would have said that instead of guessing that if I actually had 
> docs ;-)

Aw, g'wan wid zchew.... I'm sure QLogic will give you docs... :-)



Hmph.... now that I actually have one PC with > 4GB memory, I guess I'd better
start looking to make sure my own driver works right......



