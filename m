From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 00/12] IB/srp patches for kernel v4.2
Date: Mon, 18 May 2015 13:21:30 +0200
Message-ID: <5559CB3A.6060102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello Doug,

My own testing and code review of the SRP initiator driver during the 
past months resulted in a series of twelve patches with bug fixes, 
source code simplifications and other improvements. Patches 1..6 are bug 
fixes and have been tagged for the stable kernel series. These patches 
have been tested against kernel v4.1-rc3. Please consider these patches 
for the v4.2 merge window.

The changes compared to the previous version of this series are as follows:
- Dropped the target->connected state.
- Dropped patch "IB/srp: Make CM timeout dependent on subnet timeout".
- Moved a change from patch "IB/srp: Fix reconnection failure handling"
   into patch "IB/srp: Remove !ch->target tests from the reconnect code".

The individual patches in this series are:
0001-scsi_transport_srp-Introduce-srp_wait_for_queuecomma.patch
0002-scsi_transport_srp-Fix-a-race-condition.patch
0003-IB-srp-Remove-an-extraneous-scsi_host_put-from-an-er.patch
0004-IB-srp-Fix-a-connection-setup-race.patch
0005-IB-srp-Fix-connection-state-tracking.patch
0006-IB-srp-Fix-reconnection-failure-handling.patch
0007-scsi_transport_srp-Reduce-failover-time.patch
0008-IB-srp-Remove-superfluous-casts.patch
0009-IB-srp-Rearrange-module-description.patch
0010-IB-srp-Remove-a-superfluous-check-from-srp_free_req_.patch
0011-IB-srp-Remove-ch-target-tests-from-the-reconnect-cod.patch
0012-IB-srp-Add-64-bit-LUN-support.patch

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
