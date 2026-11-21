Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795279146;
	b=sfQ6MOSgEzwwIMe6APShgDhkF58PwbQ6DH71UNa7U4jyT1f8yMsfVRksPtfXvM12HvmK
	 Dp9dH6/vbFGcd9FuB/q+3jQofK9UUImGUZ0Nhq8bszC6THfIISLADAhxvakPIodQ5DnZr
	 GKwoxJmUgeOhbfy1LddXZjiiB5mxwEnxulbby5pUGa0S1ItLso1rAEM6iac2yg5wIBRF4
	 PnipEx4WTFpGhnpnDW0t7oFqzymqoQfwdQ+WuckKQ+5dFAS8ywUr7BT0uZaLh2ImfC9V6
	 /R50IW8pqSGayWVlnls1xh+x0P6rZMN2Hz8XAr+UKPDuNJj9QWCA3OY5jxC1PRuliyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795279146;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Subject:From:To:Cc:
	 Date:Message-ID:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=UvpOy7GOb9rkObKegTI8SaLmn0rbNgwEAUXCgiEk9Sg=;
	b=J7Cn90Z2CyR1CRP61+btXYP7Lxu3z4cbV23gsoo6gXCmVUyDLxBZefFbkjSBPk5mJ7uf
	 wBHbFDGzQQr5/XXxEEKvlCmaGOnmXkdJJ/ShCzik+NuYqHDj58YLi8n0D8GxdR4jslb6F
	 wDDgXkfs7j/6CY4ydKMCTjF4cUKxbE/UgEQQXnvpl272wwyYrRrCsnvL0sa9TuFgVjMpK
	 DN/6JXDfXvfpk9rWuQDfLPRTVwoJFPUhJP+TBgRdF1Jpfmmt6WQcjewXXmoIScwHVMLNG
	 RpGoY9f9x9mvet7fXNaSxKR39gPIT5ZqExi0CAeRgULcE8jvGIMk3DK2PMQt7HIPn1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f+MzvHFf;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAA6606A32A
	for <linux-scsi@vger.kernel.org>; Sat, 21 Nov 2026 16:39:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEAA6606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f+MzvHFf
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so13230345e9.0
        for <linux-scsi@vger.kernel.org>; Sat, 21 Nov 2026 08:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795279143; x=1795883943; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :cc:to:from:subject:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UvpOy7GOb9rkObKegTI8SaLmn0rbNgwEAUXCgiEk9Sg=;
        b=f+MzvHFfqQ9WcbUSNKxJj1Ic+3RE+07hDar/TjwNI5eDF9Qio/PkinckXvA/B9AC4q
         SQZJsP69aC01AzYvoojV9pj8fpG7bmLXfjM83jVrB2QwD/3JahcKWGlzGFztuyk0SE4l
         C9Wbx73I5pQxtxIQRauurGKZZZyWH5csSjD/6BUu7b12cLSa3ufRkyAOlSZ1VFUUp8yh
         kOCQ65OkPWm/SEe+z7C3wxy37KuDBaElNZeOtipOTXYGi8uAczrYwqeotlRWPxz+64i1
         Y4I2dkkPzLS8XuAQt+7hkD3x8jdYamrzMoUaPT6rjiwk4aNIvDAIqodTht+Mnk96mZA4
         IbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795279143; x=1795883943;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :cc:to:from:subject:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UvpOy7GOb9rkObKegTI8SaLmn0rbNgwEAUXCgiEk9Sg=;
        b=qdAP8OSulpSt+oXR3A0UZPL295HSbc9UmV1O3SuJiAWSrRFeZ20mN/V6oqYlqvFk8r
         FbjqfGPTWWf87hDT19POMkczszKyTt9xM/RFIKvhE7axYe2hs5Zflr10hQANj4tVpMyN
         2zxaOcEgz1fcUDtEHAInjlWTHKJFOxcQt3Escihfq/ym35tg+xWVLxordKbK6OOIxUqa
         GKom1a88ZJ8jrD/fvDDvzQQxMItA3Er3Sa3azY27PhA8WGKT4ukTDEcTk/UMvgxe+dsG
         Ddwq0FRBAWNzG9nvFdDg65uLi9DodlpqYghJ0/IIOHhVzGqpqUHvyPzCuryaQ5o1Hvyb
         EunA==
X-Gm-Message-State: APuU4Z/TprijvTHv5t4JLhL5S07sCVnIAiHQ76OXMR65W3Rr1VVUR67m
	jjECOi+3Yqk03AC6Ww0JOxLV8xDEyB3BWn//22IwrAbOw7L1f7Zp8uky05g0CXik5SCHm5mj
X-Gm-Gg: AZFdTZfdB/zejrD1okDfSoAeHmi8fejuYKgFTg1Iat4JA+N0HlWb1DG2o08qzWKiSPU
	3D8v2WMjg3P0wy4c5j/Af8VGzm/Lz+P1NYJL5x9wBxIFIPW5rZrxbeAZIpzqE4ZUHKVQyqY2emO
	eVzNA58oTidAk/fwFU/YcJ279d6MX5INwZXZ7Cd+xEkISxOpswBAtBvTd8OdexLgKQ5UKMUVQo+
	3qt575gbDHYiFMmg67mrucNf+Ev+l/B/5/LzAJhO4DnuDl4rDotawB7f/bzOLlfwszc+wvQvlFx
	XKBYQrfp6fG6eYm2qMsx+Yu5KqHASYzVfYbXo5J+FNQr/8/Ia2LqrJ7+/WTPrgTto2W8pViIJa+
	vSmp0et/MvhDBit7WshjWzPcPaugXcYrmVORDHsylTp6VTK2AVHj7RARiKl3NWYYpgKB99atqVj
	jk/p6j37+T1mpkHlVYx8aHwXAyXCD58hIU8+cY9z2DEV48K00xDwtDGOzy73r+N5rkonRHO74RO
	Wo8DAxXCmrEuQWP8pefKq8WQY2DaGUmLbukgMCKzq3UWO9Tepta+7MbG7gZmExFIIlFk+YVH+24
	BJHkxHNHiHaih+nNIXMuGjKrMrDY3PnvvWmekmSniHz0
X-Received: by 2002:a05:600c:5246:b0:4bb:60ba:49e0 with SMTP id 5b1f17b1804b1-4bb88930707mr157734315e9.26.1795279143087;
        Sat, 21 Nov 2026 08:39:03 -0800 (PST)
Received: from [10.77.1.44] ([94.188.8.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf61b8sm11212895f8f.19.2026.11.21.08.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 08:39:02 -0800 (PST)
Subject: [PATCH 0/1] scsi: target: iscsi: fix use-after-free in iscsit_stop_session()
From: Vitalii Dodonov <dreamer.two@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org,target-devel@vger.kernel.org
Date: Sat, 21 Nov 2026 19:38:57 +0300
Message-ID: <179527913740.32224.2426414360492240680@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

The iSCSI target panics with a general protection fault inside
iscsit_stop_session() when a session that has more than one connection is
torn down while another thread closes one of those connections.

iscsit_stop_session() walks sess->sess_conn_list with
list_for_each_entry_safe() and drops sess->conn_lock inside the loop.  A
connection that is being shut down concurrently runs iscsit_close_connection(),
which removes itself from the list with list_del() under the same lock and
leaves LIST_POISON1 in conn->conn_list.next.  Pinning the next connection with
iscsit_inc_conn_usage_count() keeps the object alive, but not the list links,
so the following iteration computes conn_tmp = list_next_entry() from the
poisoned pointer and passes it to iscsit_inc_conn_usage_count(), which takes a
spinlock at *(conn_tmp + offsetof(conn_usage_lock)) and faults on
0xdead000000000004.

Crash, 7.3.0-11-generic, LIO target with MaxConnections=8, Microsoft iSCSI
initiator holding 8 MC/S connections, graceful reboot of the initiator while
I/O is in flight:

  Oops: general protection fault, probably for non-canonical address 0xdead000000000004: 0000 [#1] SMP PTI
  CPU: 0 UID: 0 PID: 9028 Comm: kworker/0:2 Not tainted 7.3.0-11-generic #12-Ubuntu PREEMPT(lazy)
  Workqueue: events iscsi_target_do_login_rx [iscsi_target_mod]
  RIP: 0010:_raw_spin_lock_bh+0x18/0x50
  RDI: dead000000000004   RBX: deacfffffffffcb0   R15: deacfffffffffcb0
  Call Trace:
   ? iscsit_inc_conn_usage_count+0x1b/0x40 [iscsi_target_mod]
   iscsit_stop_session+0x7d/0x1b0 [iscsi_target_mod]
   iscsi_check_for_session_reinstatement+0x1e1/0x290 [iscsi_target_mod]
   iscsi_target_handle_csg_one+0x135/0x160 [iscsi_target_mod]
   iscsi_target_do_login+0x32/0xe0 [iscsi_target_mod]
   iscsi_target_do_login_rx+0x2d2/0x420 [iscsi_target_mod]
   process_one_work+0x1dc/0x3f0
   ...
  Kernel panic - not syncing: Fatal exception in interrupt

The same fault is reachable from the logout path:
iscsit_stop_session <- iscsit_logout_post_handler <- iscsit_response_queue <-
iscsi_target_tx_thread, with the identical 0xdead000000000004.

Where it was first seen (field report).  A Proxmox VE host (7.0.14-9-pve,
later 7.0.14-28-pve) exported zvols through LIO to Windows 11 clients using
the Microsoft iSCSI initiator with MC/S.  The host had been stable for 95 days
with MaxConnections=1; after raising it to 2 there were four panics in one
night, all with the same general protection fault at 0xdead000000000004 and
the logout stack above, and the journal of one of them contains "Received
logout request on connection that is not in logged in state".  The panic also
reproduced on 7.0.14-28-pve, so it is not tied to a single build.  The module
carrying this fix has been running on that host for 9 days with
MaxConnections=4 and 72 active iSCSI connections, without a single panic.

Reproducer (any MC/S-capable initiator; open-iscsi does not implement MC/S, so
a Microsoft iSCSI initiator was used):

 1. LIO target with MaxConnections=8, no CHAP, generate_node_acls=1.  The
    value lives in configfs and is not exported by targetcli:

      echo 8 > /sys/kernel/config/target/iscsi/<iqn>/tpgt_1/param/MaxConnections

    With MaxConnections=1 the extra connection is refused with
    ISDSC_TOO_MANY_CONNECTIONS and nothing happens, so the target has to be
    configured first.

 2. Initiator: log in, for example on Windows

      Connect-IscsiTarget -NodeAddress <iqn> -TargetPortalAddress <ip>

    and then add the remaining connections to the *same* session, one call
    per connection:

      iscsicli SessionList                 # take the "Session Id"
      iscsicli ListInitiators              # -> ROOT\ISCSIPRT\0000_0
      iscsicli QAddConnection <SessionId> ROOT\ISCSIPRT\0000_0 <portal-ip>

    Repeat until the session holds MaxConnections connections.
    AddIScsiConnectionW() does the same thing programmatically, and the
    "MCS..." button in the iSCSI Initiator GUI (target -> Properties ->
    Sessions) as well.

 3. Bring the LUN online, mount a filesystem on it and start writing to it.

 4. Reboot the initiator gracefully while the I/O is still in flight; repeat.
    The stock module crashed on the 2nd-4th cycle (2 panics in ~20 minutes).

Results: stock module 2 crashes in 8 cycles, patched module 0 in 118 cycles
(the target stayed up for the whole run).

Patch 1/1 takes a snapshot of the connections, with a reference on each, while
conn_lock is held, and then works only on that snapshot; the order in which the
connections are reinstated is unchanged.

Vitalii Dodonov (1):
  scsi: target: iscsi: fix use-after-free in iscsit_stop_session()

 drivers/target/iscsi/iscsi_target.c | 68 ++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 21 deletions(-)
