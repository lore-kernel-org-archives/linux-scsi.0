From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 4/12]  qla2xxx: Update license.
Date: Wed, 19 Oct 2005 10:37:07 -0700
Message-ID: <20051019173707.GO9087@plap.qlogic.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231614.27191.9897.sendpatchset@plap.qlogic.com> <1129275031.2873.3.camel@laptopd505.fenrus.org> <20051014162701.GA19098@plap.qlogic.org> <1129315644.5359.7.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:23681 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751185AbVJSRhI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 13:37:08 -0400
Content-Disposition: inline
In-Reply-To: <1129315644.5359.7.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Arun Mittal <arun.mittal@qlogic.com>

On Fri, 14 Oct 2005, Arjan van de Ven wrote:

> If you want the firmware issue improved, make the *firmware* BSD
> licensed. And only the firmware. But leave the driver GPL.
> And probably make it optional and allow a request_firmware() interface
> as well, so that people/distributions who don't want the built in one
> can use the request_firmware() option instead.

Here's the updated license we'd like to propose.  Please note the
verbiage regarding the questionable relicensing of the driver codes
has been removed.

On ACK, I'll re-diff my original patch and submit.

Regards,
Andrew Vasquez

---
Copyright (c)  2003-2005 QLogic Corporation
QLogic Linux Fibre Channel HBA Driver

This program includes a device driver for Linux 2.6 that may be
distributed with QLogic hardware specific firmware binary file.
You may modify and redistribute the device driver code under the
GNU General Public License as published by the Free Software
Foundation (version 2 or a later version).

You may redistribute the hardware specific firmware binary file
under the following terms:

	1. Redistribution of source code (only if applicable),
	   must retain the above copyright notice, this list of
	   conditions and the following disclaimer.

	2. Redistribution in binary form must reproduce the above
	   copyright notice, this list of conditions and the
	   following disclaimer in the documentation and/or other
	   materials provided with the distribution.

	3. The name of QLogic Corporation may not be used to
	   endorse or promote products derived from this software
	   without specific prior written permission

REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
COMBINATION WITH THIS PROGRAM.
