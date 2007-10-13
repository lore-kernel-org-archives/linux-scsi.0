From: Dave Jones <davej@redhat.com>
Subject: aic build failure in latest linus git tree.
Date: Fri, 12 Oct 2007 22:55:50 -0400
Message-ID: <20071013025550.GA17161@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbXJMDKa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2007 23:10:30 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id l9D3AMkW025903
	for <linux-scsi@vger.kernel.org>; Fri, 12 Oct 2007 23:10:30 -0400
Received: from gelk.kernelslacker.org (vpn-14-15.rdu.redhat.com [10.11.14.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9D2tomA010928
	for <linux-scsi@vger.kernel.org>; Fri, 12 Oct 2007 22:55:51 -0400
Received: from gelk.kernelslacker.org (localhost.localdomain [127.0.0.1])
	by gelk.kernelslacker.org (8.14.1/8.13.8) with ESMTP id l9D2toRX017718
	for <linux-scsi@vger.kernel.org>; Fri, 12 Oct 2007 22:55:50 -0400
Received: (from davej@localhost)
	by gelk.kernelslacker.org (8.14.1/8.14.1/Submit) id l9D2towG017717
	for linux-scsi@vger.kernel.org; Fri, 12 Oct 2007 22:55:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
make -C drivers/scsi/aic7xxx/aicasm
*** Install db development libraries
gcc -I/usr/include -I. aicasm.c aicasm_symbol.c aicasm_gram.c aicasm_ma=
cro_gram.c aicasm_scan.c aicasm_macro_scan.c -o aicasm -ldb
aicasm_symbol.c:48:19: error: aicdb.h: No such file or directory
aicasm_symbol.c:63: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=
=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__attrib=
ute__=E2=80=99 before =E2=80=98*=E2=80=99 token
aicasm_symbol.c: In function =E2=80=98symbol_delete=E2=80=99:
aicasm_symbol.c:86: error: =E2=80=98symtable=E2=80=99 undeclared (first=
 use in this function)
aicasm_symbol.c:86: error: (Each undeclared identifier is reported only=
 once
aicasm_symbol.c:86: error: for each function it appears in.)
aicasm_symbol.c:87: error: =E2=80=98DBT=E2=80=99 undeclared (first use =
in this function)
aicasm_symbol.c:87: error: expected =E2=80=98;=E2=80=99 before =E2=80=98=
key=E2=80=99
aicasm_symbol.c:89: error: =E2=80=98key=E2=80=99 undeclared (first use =
in this function)
aicasm_symbol.c: In function =E2=80=98symtable_open=E2=80=99:
aicasm_symbol.c:133: error: =E2=80=98symtable=E2=80=99 undeclared (firs=
t use in this function)
aicasm_symbol.c:134: error: =E2=80=98DB_HASH=E2=80=99 undeclared (first=
 use in this function)
aicasm_symbol.c: In function =E2=80=98symtable_close=E2=80=99:
aicasm_symbol.c:147: error: =E2=80=98symtable=E2=80=99 undeclared (firs=
t use in this function)
aicasm_symbol.c:148: error: =E2=80=98DBT=E2=80=99 undeclared (first use=
 in this function)
aicasm_symbol.c:148: error: expected =E2=80=98;=E2=80=99 before =E2=80=98=
key=E2=80=99
aicasm_symbol.c:149: error: expected =E2=80=98;=E2=80=99 before =E2=80=98=
data=E2=80=99
aicasm_symbol.c:151: error: =E2=80=98key=E2=80=99 undeclared (first use=
 in this function)
aicasm_symbol.c:151: error: =E2=80=98data=E2=80=99 undeclared (first us=
e in this function)
aicasm_symbol.c:151: error: =E2=80=98R_FIRST=E2=80=99 undeclared (first=
 use in this function)
aicasm_symbol.c: In function =E2=80=98symtable_get=E2=80=99:
aicasm_symbol.c:169: error: =E2=80=98DBT=E2=80=99 undeclared (first use=
 in this function)
aicasm_symbol.c:169: error: expected =E2=80=98;=E2=80=99 before =E2=80=98=
key=E2=80=99
aicasm_symbol.c:170: error: expected =E2=80=98;=E2=80=99 before =E2=80=98=
data=E2=80=99
aicasm_symbol.c:173: error: =E2=80=98key=E2=80=99 undeclared (first use=
 in this function)
aicasm_symbol.c:176: error: =E2=80=98symtable=E2=80=99 undeclared (firs=
t use in this function)
aicasm_symbol.c:176: error: =E2=80=98data=E2=80=99 undeclared (first us=
e in this function)
aicasm_symbol.c: In function =E2=80=98symtable_dump=E2=80=99:
aicasm_symbol.c:472: error: =E2=80=98DBT=E2=80=99 undeclared (first use=
 in this function)
aicasm_symbol.c:472: error: expected =E2=80=98;=E2=80=99 before =E2=80=98=
key=E2=80=99
aicasm_symbol.c:473: error: expected =E2=80=98;=E2=80=99 before =E2=80=98=
data=E2=80=99
aicasm_symbol.c:477: error: =E2=80=98symtable=E2=80=99 undeclared (firs=
t use in this function)
aicasm_symbol.c:486: error: =E2=80=98R_FIRST=E2=80=99 undeclared (first=
 use in this function)
aicasm_symbol.c:487: error: =E2=80=98key=E2=80=99 undeclared (first use=
 in this function)
aicasm_symbol.c:487: error: =E2=80=98data=E2=80=99 undeclared (first us=
e in this function)
aicasm_symbol.c:524: error: =E2=80=98R_NEXT=E2=80=99 undeclared (first =
use in this function)
make[4]: *** [aicasm] Error 1
make[3]: *** [drivers/scsi/aic7xxx/aicasm/aicasm] Error 2
make[2]: *** [drivers/scsi/aic7xxx] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2


--=20
http://www.codemonkey.org.uk
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
