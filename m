From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: coding style question
Date: Wed, 25 Feb 2004 17:02:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF823D530C.D81AE9B7-ON87256E45.00835477-88256E46.0000088F@us.ibm.com>
References: <c1itid$7md$1@dent.deepthot.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:31150 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261469AbUBZACw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 19:02:52 -0500
In-Reply-To: <c1itid$7md$1@dent.deepthot.org>
List-Id: linux-scsi@vger.kernel.org
To: Jay Denebeim <denebeim@deepthot.org>
Cc: linux-scsi@vger.kernel.org

>Personally I
>never found that it did that for me, the 'struct' always seemed
>redundant.

I don't find it redundant at all -- it tells me the type is a structure as 
opposed to a scalar or pointer.  Realistically, no one studies the 
declarations of types before reading the code that uses them.  When I see 
a variable foo, it helps me a lot to guess what the variable is if I know 
it is a structure.

For that reason, the usual anti-typedef rule is just "we hate typedefs for 
structs," since the only difference between "struct foo" and "foo_t" is 
that one uses slightly fewer characters and obscures the fact that it is a 
structure.  On the other hand, the difference between "int" and "pid_t" is 
much greater.  The name "pid_t" carries a lot of information in it that 
"int" does not.

