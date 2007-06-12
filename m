From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Question: vport_disable attribute under /sys/class/fc_vport
Date: Tue, 12 Jun 2007 07:23:56 -0400
Message-ID: <466E824C.8080703@emulex.com>
References: <A6970E9A290F3F4682E1EAD0EA14F32B011417B7@AVEXCH2.qlogic.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39299 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXFLLYL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2007 07:24:11 -0400
In-Reply-To: <A6970E9A290F3F4682E1EAD0EA14F32B011417B7@AVEXCH2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>


The only thing that should keep the attribute being shown is whether
you have a non-zero value for the template .vport_disable function.

Double-checked it on my systems...

-- james s

Seokmann Ju wrote:
> Hello James,
> 
> I've got a question on NPIV framwork that is included in FC transport
> layer. I'm using 2.6.22-rc3 with your NPIV-based vport patchset.
> If I understood correctly, vport_disable and vport_delete attributes
> have to be listed under /sys/class/fc_vport/vport-2:0-2/, once the
> 'vport-2:0-2' created successfully.
 >
> To make this happen, fc_function_template for the vport has modified to
> add wrapper function for vport_disable and vport_delete in the driver.
> However, in my result, I am only able to see vport_delete.
> For some reason, vport_disable is not listed under the directory.
> 
> Can you please comment what possible reasons are there for this?


