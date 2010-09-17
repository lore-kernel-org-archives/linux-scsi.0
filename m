From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand()
 caller
Date: Thu, 16 Sep 2010 18:29:09 -0700
Message-ID: <1284686949.7280.99.camel@schen9-DESK>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-09-16 at 15:35 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings all,
> 
> This series contains the first round of a whole-sale conversion for droping
> struct Scsi_Host->host_lock around struct Scsi_Host->queuecommand() within
> scsi_dispatch_cmd().  So with this first patch the only part of scsi_dispatch_cmd()
> that is protected by host_lock is scsi_cmd_get_serial)_.
> 

Maybe we can change the host->cmd_serial_number to atomic and totally
avoid the need to take host_lock.

Tim
