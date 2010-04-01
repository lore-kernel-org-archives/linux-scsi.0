From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [LSF/VM TOPIC] Generic SAN Management via Oracle VM Storage Connect
 Plugin.
Date: Wed, 31 Mar 2010 20:52:32 -0500
Message-ID: <4BB3FC60.1050405@cs.wisc.edu>
References: <20100401010539.GF28680@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58869 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab0DABsd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2010 21:48:33 -0400
In-Reply-To: <20100401010539.GF28680@mail.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf10-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org

On 03/31/2010 08:05 PM, Joel Becker wrote:
> [ I was asked to Cc: linux-scsi, so here it is ]
>
>
> [Topic]
> Generic SAN Management via Oracle VM Storage Connect Plugin.
>
> [Abstract]
> Managing storage in the SAN often requires using a different tool for
> each vendor in the environment.  Oracle has defined a plugin interface
> for SAN management, the (sorry about the mouthful) Oracle VM Storage
> Connect Plugin.  The important part is that many of our storage partners
> have agreed to not only help, but actively author plugins for their
> storage hardware.
>
> While initiated for the Oracle VM product, I've written a standalone
> application that uses the plugin, giving a unified view of storage that
> can be managed from one place.  The program will be open source, of
> course.  I'm looking for input from storage folks at LFS on what
> I can do to make this even more useful to general SAN management.
>

Sounds interesting. I have been trying to just get initiator tools and 
libs that work with all hbas. We have a common iscsi tool for iscsi 
initiators and was hoping fcoeadmin could be made more generic to work 
for all fcoe and fc drivers (there is work to make a the linux hbaapi 
lib work for all drivers too).

Is your interface based on anything like SMI-S, or something new? It 
will work on the initiator and targets, right? Will it work on switches?
