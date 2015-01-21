From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: tcmu-runner (target userspace passthrough daemon) development
Date: Tue, 20 Jan 2015 16:35:35 -0800
Message-ID: <1421800535.9970.27.camel@haakon3.risingtidesystems.com>
References: <54BEE479.4050503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42025 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbbAUAfh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2015 19:35:37 -0500
In-Reply-To: <54BEE479.4050503@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2015-01-20 at 15:27 -0800, Andy Grover wrote:
> Hi all,
> 
> tcmu-runner is a userspace daemon that simplifies the configuration and 
> processing of SCSI commands from LIO to userspace handlers, via the new 
> TCMU userspace passthrough backstore.
> 
> https://github.com/agrover/tcmu-runner
> 

Thanks for posting.  ;)

> As a proof-of-concept, I've implemented a Gluster backend handler. I'm 
> looking for code review and collaborators, as well as suggestions on 
> what other userspace handlers we might want to work on. Tape or optical 
> jukebox emulation? VMDK files?? Video RAM???

How about a user-space handler for qcow2, so we could have a mechanism
for exposing qcow2 images into KVM guest using vhost-scsi export..?

Ideally there would be a library that QEMU provides so that from TCMU's
user-space handler perspective, it's simply issuing fd reads/writes into
qcow2 library code that is doing the fancy feature stuff outside of
user-space handler logic..

--nab

