Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39FFC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 17:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A938960F9E
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 17:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242332AbhJOSBY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 14:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242292AbhJOSBY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Oct 2021 14:01:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6EEEB6120D
        for <linux-scsi@vger.kernel.org>; Fri, 15 Oct 2021 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634320757;
        bh=kQU6TWJC5pi4bm5kNPQd/wuwtJogd/62991/58o8Jgk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=uyXqDU4/6gJvsdJhSF8A4jHvXkZ2Kwc3xttTqNSKt3yuQZBbbETkSwwegm2IjS5hC
         l+vQN+D8oB7PFFDQed1RBKw6/6m9WpdR0kFrdXj5c1ph4Na/x0sxZ2aQsS38kX+eVL
         L/EHMdYCtDnkPDWG4He1b2qar3bvr7KC1glh5EyqV81ZuknNBKoenyueKKnTs6bwbA
         NcDZiOIS06PS3QGwi7jB2XKvmx0bYYovn/NrXHXFE5DpAuHliDdcno3FDKapyxyvAG
         svgCi5G+vGA/Yz9+biPuxkPMU2YfrnhTfocHQK/JKcdCitRQ3dCzHnueSOTkvMfHkg
         fE33mkOPfmCtg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Fri, 15 Oct 2021 17:59:16 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ucelsanicin@yahoo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-G8TF5FraXu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

Ahmed Sayeed (ucelsanicin@yahoo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ucelsanicin@yahoo.com

--- Comment #13 from Ahmed Sayeed (ucelsanicin@yahoo.com) ---
/gdb/arch/arc.c:117:43:   required from here http://www.compilatori.com/=20
/usr/include/c++/4.8.2/bits/hashtable_policy.h:195:39: error: no matching
function for call to =E2=80=98std::pair<const arc_arch_features, const
std::unique_ptr<target_desc, http://www-look-4.com/ target_desc_deleter>
>::pair(const arc_arch_features&, target_desc*&)=E2=80=99
  : _M_v(std::forward<_Args>(__args)...) { } http://www.acpirateradio.co.uk/
                                       ^=20
/usr/include/c++/4.8.2/bits/hashtable_policy.h:195:39: note: candidates are:
https://www.webb-dev.co.uk/
In file included from /usr/include/c++/4.8.2/utility:70:0,
                 from /usr/include/c++/4.8.2/tuple:38,
http://www.logoarts.co.uk/
                 from /usr/include/c++/4.8.2/functional:55,=20
                 from ../../gdb/../gdbsupport/ptid.h:35,
https://komiya-dental.com/
                 from ../../gdb/../gdbsupport/common-defs.h:123,
                 from ../../gdb/arch/arc.c:19: http://www.slipstone.co.uk/

/usr/include/c++/4.8.2/bits/stl_pair.h:206:9: note: template<class ... _Arg=
s1,
long unsigned int ..._Indexes1, class ... _Args2, long unsigned int
..._Indexes2> std::pair<_T1, http://embermanchester.uk/=20=20
_T2>::pair(std::tuple<_Args1 ...>&, std::tuple<_Args2 ...>&,
std::_Index_tuple<_Indexes1 ...>, std::_Index_tuple<_Indexes2 ...>)
         pair(tuple<_Args1...>&, tuple<_Args2...>&, http://connstr.net/
         ^
-------->8---------
http://joerg.li/
Thanks to Tome de Vries' investigation, same fix applies in ARC's case as w=
ell:
--------8<--------- http://www.jopspeech.com/
diff --git a/gdb/arch/arc.c b/gdb/arch/arc.c
index 3808f9f..a5385ce 100644
--- a/gdb/arch/arc.c
+++ b/gdb/arch/arc.c http://www.wearelondonmade.com/
@@ -114,7 +114,7 @@ struct arc_arch_features_hasher
   target_desc *tdesc =3D arc_create_target_description (features);
https://waytowhatsnext.com/

   /* Add the newly created target description to the repertoire.  */
-  arc_tdesc_cache.emplace (features, tdesc); http://www.iu-bloomington.com/
+  arc_tdesc_cache.emplace (features, target_desc_up (tdesc));

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
