From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: 2.5.63/64 do not boot: loop in scsi_error
Date: Thu, 6 Mar 2003 00:37:42 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030306083742.GA2222@beaverton.ibm.com>
References: <UTC200303060639.h266dIo22884.aeb@smtp.cwi.nl> <20030306064921.GA1425@beaverton.ibm.com> <Pine.LNX.4.50.0303060256200.25282-100000@montezuma.mastecende.com> <20030306083054.GB1503@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030306083054.GB1503@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Zwane Mwaikambo <zwane@linuxpower.ca>, Andries.Brouwer@cwi.nl, torvalds@transmeta.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Mike Anderson [andmike@us.ibm.com] wrote:
> Zwane Mwaikambo [zwane@linuxpower.ca] wrote:
> > scsi1 : QLogic ISP1020 SCSI on PCI bus 04 device 70 irq 89 MEM base 0xf8a18000
> > scsi: Device offlined - not ready or command retry failed after error recovery: host 1 channel 0 id 0 lun 0
> > scsi: Device offlined - not ready or command retry failed after error recovery: host 1 channel 0 id 1 lun 0
> > 
> 
> Did this work in 2.5.62? The qlogicisp driver does have any error
The above line should read "does not have any error"
> handlers. Any error will cause a device offline state. You
> should see a message at boot like:
> ERROR: This is not a safe way to run your SCSI host            
> ERROR: The error handling must be added to this driver

-andmike
--
Michael Anderson
andmike@us.ibm.com

