From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 1/2] tcm: Add support for BIDI operation and
	XDWRITE_READ_10 emulation
Date: Wed, 15 Sep 2010 15:40:59 -0700
Message-ID: <1284590459.13344.42.camel@haakon2.linux-iscsi.org>
References: <1284590521-6254-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1284590521-6254-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-09-15 at 15:42 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This v2 patch series adds BIDI-COMMANDS support to TCM Core.  This
> includes the following for struct se_cmd to handle BIDI READ payloads using a new
> struct se_transport_task->t_mem_bidi_list and struct se_transport_task->t_tasks_se_bidi_num.
> The model employed is to keep the WRITE payload at struct se_transport_task->t_mem_list,
> and add a new BIDI READ payload memory list at struct se_transport_task->t_mem_bidi_list.
> 

Sorry, this patch is a PRE rebased DUPE..  Please ignore it.

Best,

--nab
