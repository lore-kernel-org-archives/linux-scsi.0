From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target fixes for v3.7-rc4
Date: Tue, 30 Oct 2012 21:49:57 -0700
Message-ID: <1351658997.1898.25.camel@haakon2.linux-iscsi.org>
References: <1351657764.1898.20.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1351657764.1898.20.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Bernhard Kohl <bernhard.kohl@nsn.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-10-30 at 21:29 -0700, Nicholas A. Bellinger wrote:
> Hello Linus!
> 
> The following are the current target pending fixes headed for v3.7-rc4
> code.  This includes the following highlights:
> 
> - Fix long-standing qla2xxx target bug where certain fc_port_t state
> transitions could cause the internal session b-tree list to become
> out-of-sync. (Roland)
> - Fix task management double free of se_cmd descriptor in exception path
> for users of target_submit_tmr(). (nab)
> - Re-introduce simple NOP emulation of REZERO_UNIT, SEEK_6, and SEEK_10
> SCSI-2 commands in order to support legacy initiators that still require
> them.  (Bernhard)
> 
> Note these three patches are also CC'ed to stable.
> 
> Also, there a couple of outstanding (external) regressions that are
> still being tracked down for tcm_fc(FCoE) and tcm_vhost fabrics for
> v3.7.0 code, so please expect another PULL as these issues identified ->
> resolved.
> 

Whooops, forgot to include the usual location for an rc-fixes PULL:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

Thanks !

--nab
