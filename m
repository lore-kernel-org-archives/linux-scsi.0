From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: st.c block limits
Date: Thu, 1 Aug 2002 09:14:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <002001c2395d$6e842150$e0019d89@cybernetics.com>
References: <3D491F96.5040604@ntlworld.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D491F96.5040604@ntlworld.com>
List-Id: linux-scsi@vger.kernel.org
To: 'ael' <law_ence.dev@ntlworld.com>
Cc: linux-scsi@vger.kernel.org

> >># tar -cf /dev/ntape blah_home.tar.bz2; mt  tell

> The tape has a real 10GB capacity. (I believe.)  The 20BG
> blocks is correct
> for the default block size of 512. So compression is not an
> issue here. And
> the report above is actually 17.8/2 = 8.9 GB :-(

Some compression algorithms will actually expand data by a significant
amount.  For example, many implementations of ALDC compression will give a
compression ratio of 0.8 on random data.  In your example above you are
writing a .bz2 file (which is already compressed), so it would probably
expand if compressed again.  Try turning drive internal compression off:

mt -f /dev/ntape compression off

This might help squeeze a little more data on your tape.

Anthony Battersby
Cybernetics

