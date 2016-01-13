From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 3/4] target: Fix change depth se_session reference
 usage
Date: Wed, 13 Jan 2016 18:45:16 +0200
Message-ID: <56967F1C.2070408@dev.mellanox.co.il>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com>
 <1452457724-10629-4-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452457724-10629-4-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org


> Also, it includes a bug-fix for iscsi-target where explicit
> session shutdown in lio_tpg_shutdown_session() was not
> obtaining se_portal_group->session_lock for both cases,
> plus drop pointless wrapper.

It'd be better to move this to a dedicated patch IMO.

The other split I was going to suggest was target_get_session()
which you already took care of...
